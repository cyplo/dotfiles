var cp = require('child_process');
var fs = require('fs');
var vs = require('vscode');
var tmp = require('tmp');
var SuggestService = (function () {
    function SuggestService(config) {
        this.typeMap = {
            'Struct': vs.CompletionItemKind.Class,
            'Module': vs.CompletionItemKind.Module,
            'MatchArm': vs.CompletionItemKind.Variable,
            'Function': vs.CompletionItemKind.Function,
            'Crate': vs.CompletionItemKind.Module,
            'Let': vs.CompletionItemKind.Variable,
            'IfLet': vs.CompletionItemKind.Variable,
            'WhileLet': vs.CompletionItemKind.Variable,
            'For': vs.CompletionItemKind.Variable,
            'StructField': vs.CompletionItemKind.Field,
            'Impl': vs.CompletionItemKind.Class,
            'Enum': vs.CompletionItemKind.Enum,
            'EnumVariant': vs.CompletionItemKind.Field,
            'Type': vs.CompletionItemKind.Keyword,
            'FnArg': vs.CompletionItemKind.Property,
            'Trait': vs.CompletionItemKind.Interface,
            'Const': vs.CompletionItemKind.Variable,
            'Static': vs.CompletionItemKind.Variable,
        };
        this.documentSelector = ['rust'];
        this.config = config;
        this.listeners = [];
        var tmpFile = tmp.fileSync();
        this.tmpFile = tmpFile.name;
    }
    SuggestService.prototype.start = function () {
        var _this = this;
        this.commandCallbacks = [];
        this.linesBuffer = [];
        this.providers = [];
        this.racerPath = this.config['racerPath'] || 'racer';
        this.racerDaemon = cp.spawn(this.racerPath, ['daemon'], { stdio: 'pipe' });
        this.racerDaemon.on('error', this.stopDaemon.bind(this));
        this.racerDaemon.on('close', this.stopDaemon.bind(this));
        this.racerDaemon.stdout.on('data', this.dataHandler.bind(this));
        this.hookCapabilities();
        this.listeners.push(vs.workspace.onDidChangeConfiguration(function () {
            _this.config = vs.workspace.getConfiguration('racer');
            var newPath = _this.config['racerPath'] || 'racer';
            if (_this.racerPath != newPath) {
                _this.restart();
            }
        }));
        return new vs.Disposable(this.stop.bind(this));
    };
    SuggestService.prototype.stopDaemon = function () {
        this.racerDaemon.kill();
        this.providers.forEach(function (disposable) { return disposable.dispose(); });
        this.providers = [];
    };
    SuggestService.prototype.stopListeners = function () {
        this.listeners.forEach(function (disposable) { return disposable.dispose(); });
        this.listeners = [];
    };
    SuggestService.prototype.stop = function () {
        this.stopDaemon();
        this.stopListeners();
    };
    SuggestService.prototype.restart = function () {
        this.stop();
        this.start();
    };
    SuggestService.prototype.updateTmpFile = function (document) {
        fs.writeFileSync(this.tmpFile, document.getText());
    };
    SuggestService.prototype.definitionProvider = function (document, position, token) {
        this.updateTmpFile(document);
        var command = "find-definition " + (position.line + 1) + " " + position.character + " " + document.fileName + " " + this.tmpFile + "\n";
        return this.runCommand(command).then(function (lines) {
            if (lines.length == 0)
                return null;
            var result = lines[0];
            var parts = result.split(',');
            var position = new vs.Position(Number(parts[1]) - 1, Number(parts[2]));
            var uri = vs.Uri.file(parts[3]);
            return new vs.Location(uri, position);
        });
    };
    SuggestService.prototype.completionProvider = function (document, position, token) {
        var _this = this;
        this.updateTmpFile(document);
        var command = "complete-with-snippet " + (position.line + 1) + " " + position.character + " " + document.fileName + " " + this.tmpFile + "\n";
        return this.runCommand(command).then(function (lines) {
            lines.shift();
            //Split on MATCH, as a definition can span more than one line
            lines = lines.map(function (l) { return l.trim(); }).join('').split('MATCH ').slice(1);
            var completions = [];
            for (var _i = 0; _i < lines.length; _i++) {
                var line = lines[_i];
                var parts = line.split(';');
                var label = parts[0];
                var kindKey = parts[5];
                var detail = parts[6];
                var kind = void 0;
                if (kindKey in _this.typeMap) {
                    kind = _this.typeMap[kindKey];
                }
                else {
                    console.warn('Kind not mapped: ' + kindKey);
                    kind = vs.CompletionItemKind.Text;
                }
                //Remove trailing bracket
                if (kindKey != 'Module' && kindKey != 'Crate') {
                    var bracketIndex = detail.indexOf('{');
                    if (bracketIndex == -1)
                        bracketIndex = detail.length;
                    detail = detail.substring(0, bracketIndex).trim();
                }
                completions.push({
                    label: label,
                    kind: kind,
                    detail: detail
                });
            }
            return completions;
        });
    };
    SuggestService.prototype.parseParameters = function (line, startingPosition, stopPosition) {
        if (!stopPosition)
            stopPosition = line.length;
        var parameters = [];
        var currentParameter = '';
        var currentDepth = 0;
        var parameterStart = -1;
        var parameterEnd = -1;
        for (var i = startingPosition; i < stopPosition; i++) {
            var char = line.charAt(i);
            if (char == '(') {
                if (currentDepth == 0) {
                    parameterStart = i;
                }
                currentDepth += 1;
                continue;
            }
            else if (char == ')') {
                currentDepth -= 1;
                if (currentDepth == 0) {
                    parameterEnd = i;
                    break;
                }
                continue;
            }
            if (currentDepth == 0)
                continue;
            if (currentDepth == 1 && char == ',') {
                parameters.push(currentParameter);
                currentParameter = '';
            }
            else {
                currentParameter += char;
            }
        }
        parameters.push(currentParameter);
        return [parameters, parameterStart, parameterEnd];
    };
    SuggestService.prototype.parseCall = function (name, line, definition, position) {
        var nameEnd = definition.indexOf(name) + name.length;
        var _a = this.parseParameters(definition, nameEnd), params = _a[0], paramStart = _a[1], paramEnd = _a[2];
        var _b = this.parseParameters(line, line.indexOf(name) + name.length), callParameters = _b[0];
        var currentParameter = callParameters.length - 1;
        var nameTemplate = definition.substring(0, paramStart);
        //If function is used as a method, ignore the self parameter
        var isMethod = line.charAt(line.indexOf(name) - 1) == '.';
        if (isMethod)
            params = params.slice(1);
        var result = new vs.SignatureHelp();
        result.activeSignature = 0;
        result.activeParameter = currentParameter;
        var signature = new vs.SignatureInformation(nameTemplate);
        signature.label += '(';
        params.forEach(function (param, i) {
            var parameter = new vs.ParameterInformation(param, '');
            signature.label += parameter.label;
            signature.parameters.push(parameter);
            if (i != params.length - 1)
                signature.label += ', ';
        });
        signature.label += ') ';
        var bracketIndex = definition.indexOf('{', paramEnd);
        if (bracketIndex == -1)
            bracketIndex = definition.length;
        //Append return type without possible trailing bracket
        signature.label += definition.substring(paramEnd + 1, bracketIndex).trim();
        result.signatures.push(signature);
        return result;
    };
    SuggestService.prototype.firstDanglingParen = function (line, position) {
        var currentDepth = 0;
        for (var i = position; i >= 0; i--) {
            var char = line.charAt(i);
            if (char == ')')
                currentDepth += 1;
            else if (char == '(')
                currentDepth -= 1;
            if (currentDepth == -1)
                return i;
        }
        return -1;
    };
    SuggestService.prototype.signatureHelpProvider = function (document, position, token) {
        var _this = this;
        this.updateTmpFile(document);
        var line = document.lineAt(position.line);
        //Get the first dangling parenthesis, so we don't stop on a function call used as a previous parameter
        var callPosition = this.firstDanglingParen(line.text, position.character - 1);
        var command = "complete-with-snippet " + (position.line + 1) + " " + callPosition + " " + document.fileName + " " + this.tmpFile + "\n";
        return this.runCommand(command).then(function (lines) {
            lines = lines.map(function (l) { return l.trim(); }).join('').split('MATCH ').slice(1);
            if (lines.length == 0)
                return null;
            var parts = lines[0].split(';');
            var type = parts[5];
            if (type != 'Function')
                return null;
            var name = parts[0];
            var definition = parts[6];
            return _this.parseCall(name, line.text, definition, position.character);
        });
    };
    SuggestService.prototype.hookCapabilities = function () {
        var definitionProvider = { provideDefinition: this.definitionProvider.bind(this) };
        this.providers.push(vs.languages.registerDefinitionProvider(this.documentSelector, definitionProvider));
        var completionProvider = { provideCompletionItems: this.completionProvider.bind(this) };
        this.providers.push((_a = vs.languages).registerCompletionItemProvider.apply(_a, [this.documentSelector, completionProvider].concat(['.', ':'])));
        var signatureProvider = { provideSignatureHelp: this.signatureHelpProvider.bind(this) };
        this.providers.push((_b = vs.languages).registerSignatureHelpProvider.apply(_b, [this.documentSelector, signatureProvider].concat(['(', ','])));
        var _a, _b;
    };
    SuggestService.prototype.dataHandler = function (data) {
        var lines = data.toString().split(/\r?\n/);
        for (var _i = 0; _i < lines.length; _i++) {
            var line = lines[_i];
            if (line.length == 0)
                continue;
            if (line.startsWith('END')) {
                var callback = this.commandCallbacks.shift();
                callback(this.linesBuffer);
                this.linesBuffer = [];
            }
            else {
                this.linesBuffer.push(line);
            }
        }
    };
    SuggestService.prototype.runCommand = function (command) {
        var _this = this;
        var promise = new Promise(function (resolve, reject) {
            _this.commandCallbacks.push(resolve);
        });
        this.racerDaemon.stdin.write(command);
        return promise;
    };
    return SuggestService;
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = SuggestService;
//# sourceMappingURL=racerClient.js.map