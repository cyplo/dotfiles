/*
 * Copyright (c) 2015 "draivin" Ian Ornelas and other contributors.
 * Licensed under MIT (https://github.com/Draivin/vscode-racer/blob/master/LICENSE).
 */
"use strict";
var cp = require('child_process');
var fs = require('fs');
var vscode = require('vscode');
var tmp = require('tmp');
var pathService_1 = require('./pathService');
var filterService_1 = require('./filterService');
var StatusBarItem = (function () {
    function StatusBarItem() {
        this.statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left);
    }
    StatusBarItem.prototype.showTurnedOn = function () {
        this.setText('On');
        this.statusBarItem.command = null;
        this.statusBarItem.show();
    };
    StatusBarItem.prototype.showTurnedOff = function () {
        this.setText('Off');
        this.statusBarItem.command = null;
        this.statusBarItem.show();
    };
    StatusBarItem.prototype.showNotFound = function () {
        this.setText('Not found');
        this.statusBarItem.tooltip = 'The "racer" command is not available. Make sure it is installed.';
        this.statusBarItem.command = null;
        this.statusBarItem.show();
    };
    StatusBarItem.prototype.showCrashed = function () {
        this.setText('Crashed');
        this.statusBarItem.tooltip = 'The racer process has stopped. Click to view error';
        this.statusBarItem.command = 'rust.racer.showerror';
        this.statusBarItem.show();
    };
    StatusBarItem.prototype.setText = function (text) {
        this.statusBarItem.text = "Racer: " + text;
    };
    return StatusBarItem;
}());
var SuggestService = (function () {
    function SuggestService() {
        this.typeMap = {
            'Struct': vscode.CompletionItemKind.Class,
            'Module': vscode.CompletionItemKind.Module,
            'MatchArm': vscode.CompletionItemKind.Variable,
            'Function': vscode.CompletionItemKind.Function,
            'Crate': vscode.CompletionItemKind.Module,
            'Let': vscode.CompletionItemKind.Variable,
            'IfLet': vscode.CompletionItemKind.Variable,
            'WhileLet': vscode.CompletionItemKind.Variable,
            'For': vscode.CompletionItemKind.Variable,
            'StructField': vscode.CompletionItemKind.Field,
            'Impl': vscode.CompletionItemKind.Class,
            'Enum': vscode.CompletionItemKind.Enum,
            'EnumVariant': vscode.CompletionItemKind.Field,
            'Type': vscode.CompletionItemKind.Keyword,
            'FnArg': vscode.CompletionItemKind.Property,
            'Trait': vscode.CompletionItemKind.Interface,
            'Const': vscode.CompletionItemKind.Variable,
            'Static': vscode.CompletionItemKind.Variable
        };
        this.listeners = [];
        this.statusBarItem = new StatusBarItem();
        var tmpFile = tmp.fileSync();
        this.tmpFile = tmpFile.name;
    }
    SuggestService.prototype.racerCrashErrorCommand = function (command) {
        var _this = this;
        return vscode.commands.registerCommand(command, function () {
            _this.showErrorBuffer();
        });
    };
    SuggestService.prototype.start = function () {
        var _this = this;
        this.commandCallbacks = [];
        this.linesBuffer = [];
        this.errorBuffer = '';
        this.lastCommand = '';
        this.providers = [];
        this.racerPath = pathService_1.default.getRacerPath();
        this.statusBarItem.showTurnedOn();
        var cargoHomePath = pathService_1.default.getCargoHomePath();
        var racerSpawnOptions = { stdio: 'pipe' };
        if (cargoHomePath !== '') {
            var racerEnv = Object.assign({}, process.env, { 'CARGO_HOME': cargoHomePath });
            racerSpawnOptions.env = racerEnv;
        }
        this.racerDaemon = cp.spawn(pathService_1.default.getRacerPath(), ['--interface=tab-text', 'daemon'], racerSpawnOptions);
        this.racerDaemon.on('error', this.stopDaemon.bind(this));
        this.racerDaemon.on('close', this.stopDaemon.bind(this));
        this.racerDaemon.stdout.on('data', this.dataHandler.bind(this));
        this.racerDaemon.stderr.on('data', function (data) { return _this.errorBuffer += data.toString(); });
        this.hookCapabilities();
        this.listeners.push(vscode.workspace.onDidChangeConfiguration(function () {
            var newPath = pathService_1.default.getRacerPath();
            if (_this.racerPath !== newPath) {
                _this.restart();
            }
        }));
        return new vscode.Disposable(this.stop.bind(this));
    };
    SuggestService.prototype.stop = function () {
        this.stopDaemon(0);
        this.stopListeners();
        this.clearCommandCallbacks();
    };
    SuggestService.prototype.restart = function () {
        this.stop();
        this.start();
    };
    SuggestService.prototype.stopDaemon = function (error) {
        if (this.racerDaemon == null) {
            return;
        }
        this.racerDaemon.kill();
        this.racerDaemon = null;
        this.providers.forEach(function (disposable) { return disposable.dispose(); });
        this.providers = [];
        if (!error) {
            this.statusBarItem.showTurnedOff();
            return;
        }
        if (error.code === 'ENOENT') {
            this.statusBarItem.showNotFound();
        }
        else {
            this.statusBarItem.showCrashed();
            setTimeout(this.restart.bind(this), 3000);
        }
    };
    SuggestService.prototype.stopListeners = function () {
        this.listeners.forEach(function (disposable) { return disposable.dispose(); });
        this.listeners = [];
    };
    SuggestService.prototype.clearCommandCallbacks = function () {
        this.commandCallbacks.forEach(function (callback) { return callback([]); });
    };
    SuggestService.prototype.showErrorBuffer = function () {
        var channel = vscode.window.createOutputChannel('Racer Error');
        channel.clear();
        channel.append("Last command: \n" + this.lastCommand + "\n");
        channel.append("Racer Output: \n" + this.linesBuffer.join('\n') + "\n");
        channel.append("Racer Error: \n" + this.errorBuffer);
        channel.show(true);
    };
    SuggestService.prototype.definitionProvider = function (document, position) {
        var commandArgs = [position.line + 1, position.character, document.fileName, this.tmpFile];
        return this.runCommand(document, 'find-definition', commandArgs).then(function (lines) {
            if (lines.length === 0) {
                return null;
            }
            var result = lines[0];
            var parts = result.split('\t');
            var line = Number(parts[2]) - 1;
            var character = Number(parts[3]);
            var uri = vscode.Uri.file(parts[4]);
            return new vscode.Location(uri, new vscode.Position(line, character));
        });
    };
    SuggestService.prototype.hoverProvider = function (document, position) {
        var commandArgs = [position.line + 1, position.character, document.fileName, this.tmpFile];
        return this.runCommand(document, 'find-definition', commandArgs).then(function (lines) {
            if (lines.length === 0) {
                return null;
            }
            var result = lines[0];
            var parts = result.split('\t');
            var line = Number(parts[2]) - 1;
            var uri = vscode.Uri.file(parts[4]);
            var type = parts[5];
            var definition = parts[6];
            // Module definitions are just their path, so there is no need
            // to try processing it
            if (type === 'Module') {
                return new vscode.Hover(definition);
            }
            var docRegex = /^\/\/\/(.*)/;
            var annotRegex = /^#\[(.*?)]/;
            return vscode.workspace.openTextDocument(uri).then(function (defDocument) {
                var text = defDocument.getText().split('\n');
                var docs = [];
                while (true) {
                    --line;
                    var docLine = text[line];
                    if (docLine == null) {
                        break;
                    }
                    docLine = docLine.trim();
                    var annotMatches = docLine.match(annotRegex);
                    var docMatches = docLine.match(docRegex);
                    if (annotMatches !== null) {
                    }
                    else if (docMatches !== null) {
                        docs.push(docMatches[1]);
                    }
                    else {
                        break;
                    }
                }
                if (docs.length > 0 && !docs[0].trim().startsWith('#')) {
                    docs.push('# Description');
                }
                var bracketIndex = definition.indexOf('{');
                if (bracketIndex !== -1) {
                    definition = definition.substring(0, bracketIndex);
                }
                docs.push('```', definition.trim(), '```');
                docs.reverse();
                var processedDocs = [];
                var codeBlock = false;
                var extraIndent = 0;
                for (var i = 0; i < docs.length; i++) {
                    if (i >= 15 && docs.length !== 16 && !codeBlock) {
                        processedDocs.push('...');
                        break;
                    }
                    var docLine = docs[i];
                    if (docLine.trim().startsWith('```')) {
                        codeBlock = !codeBlock;
                        extraIndent = docLine.indexOf('```');
                        processedDocs.push(docLine);
                        continue;
                    }
                    if (codeBlock) {
                        processedDocs.push(docLine.slice(extraIndent));
                        continue;
                    }
                    // Make headers smaller
                    if (docLine.trim().startsWith('#')) {
                        processedDocs.push('##' + docLine.trim());
                        continue;
                    }
                    processedDocs.push(docLine);
                }
                return new vscode.Hover(processedDocs.join('\n'));
            });
        });
    };
    SuggestService.prototype.completionProvider = function (document, position) {
        var _this = this;
        var commandArgs = [position.line + 1, position.character, document.fileName, this.tmpFile];
        return this.runCommand(document, 'complete-with-snippet', commandArgs).then(function (lines) {
            lines.shift();
            // Split on MATCH, as a definition can span more than one line
            lines = lines.map(function (l) { return l.trim(); }).join('').split('MATCH\t').slice(1);
            var completions = [];
            for (var _i = 0, lines_1 = lines; _i < lines_1.length; _i++) {
                var line = lines_1[_i];
                var parts = line.split('\t');
                var label = parts[0];
                var type = parts[5];
                var detail = parts[6];
                var kind = void 0;
                if (type in _this.typeMap) {
                    kind = _this.typeMap[type];
                }
                else {
                    console.warn('Kind not mapped: ' + type);
                    kind = vscode.CompletionItemKind.Text;
                }
                // Remove trailing bracket
                if (type !== 'Module' && type !== 'Crate') {
                    var bracketIndex = detail.indexOf('{');
                    if (bracketIndex === -1) {
                        bracketIndex = detail.length;
                    }
                    detail = detail.substring(0, bracketIndex).trim();
                }
                completions.push({ label: label, kind: kind, detail: detail });
            }
            return completions;
        });
    };
    SuggestService.prototype.parseParameters = function (text, startingPosition) {
        var stopPosition = text.length;
        var parameters = [];
        var currentParameter = '';
        var currentDepth = 0;
        var parameterStart = -1;
        var parameterEnd = -1;
        for (var i = startingPosition; i < stopPosition; i++) {
            var char = text.charAt(i);
            if (char === '(') {
                if (currentDepth === 0) {
                    parameterStart = i;
                }
                currentDepth += 1;
                continue;
            }
            else if (char === ')') {
                currentDepth -= 1;
                if (currentDepth === 0) {
                    parameterEnd = i;
                    break;
                }
                continue;
            }
            if (currentDepth === 0) {
                continue;
            }
            if (currentDepth === 1 && char === ',') {
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
    SuggestService.prototype.parseCall = function (name, args, definition, callText) {
        var nameEnd = definition.indexOf(name) + name.length;
        var _a = this.parseParameters(definition, nameEnd), params = _a[0], paramStart = _a[1], paramEnd = _a[2];
        var callParameters = this.parseParameters(callText, 0)[0];
        var currentParameter = callParameters.length - 1;
        var nameTemplate = definition.substring(0, paramStart);
        // If function is used as a method, ignore the self parameter
        if ((args ? args.length : 0) < params.length) {
            params = params.slice(1);
        }
        var result = new vscode.SignatureHelp();
        result.activeSignature = 0;
        result.activeParameter = currentParameter;
        var signature = new vscode.SignatureInformation(nameTemplate);
        signature.label += '(';
        params.forEach(function (param, i) {
            var parameter = new vscode.ParameterInformation(param, '');
            signature.label += parameter.label;
            signature.parameters.push(parameter);
            if (i !== params.length - 1) {
                signature.label += ', ';
            }
        });
        signature.label += ') ';
        var bracketIndex = definition.indexOf('{', paramEnd);
        if (bracketIndex === -1) {
            bracketIndex = definition.length;
        }
        // Append return type without possible trailing bracket
        signature.label += definition.substring(paramEnd + 1, bracketIndex).trim();
        result.signatures.push(signature);
        return result;
    };
    SuggestService.prototype.firstDanglingParen = function (document, position) {
        var text = document.getText();
        var offset = document.offsetAt(position) - 1;
        var currentDepth = 0;
        while (offset > 0) {
            var char = text.charAt(offset);
            if (char === ')') {
                currentDepth += 1;
            }
            else if (char === '(') {
                currentDepth -= 1;
            }
            else if (char === '{') {
                return null; // not inside function call
            }
            if (currentDepth === -1) {
                return document.positionAt(offset);
            }
            offset--;
        }
        return null;
    };
    SuggestService.prototype.signatureHelpProvider = function (document, position) {
        var _this = this;
        // Get the first dangling parenthesis, so we don't stop on a function call used as a previous parameter
        var startPos = this.firstDanglingParen(document, position);
        if (!startPos) {
            return null;
        }
        var name = document.getText(document.getWordRangeAtPosition(startPos));
        var commandArgs = [startPos.line + 1, startPos.character - 1, document.fileName, this.tmpFile];
        return this.runCommand(document, 'complete-with-snippet', commandArgs).then(function (lines) {
            lines = lines.map(function (l) { return l.trim(); }).join('').split('MATCH\t').slice(1);
            var parts = [];
            for (var _i = 0, lines_2 = lines; _i < lines_2.length; _i++) {
                var line = lines_2[_i];
                parts = line.split('\t');
                if (parts[0] === name) {
                    break;
                }
            }
            if (parts[0] !== name) {
                return null;
            }
            var args = parts[1].match(/\${\d+:\w+}/g);
            var type = parts[5];
            var definition = parts[6];
            if (type !== 'Function') {
                return null;
            }
            var callText = document.getText(new vscode.Range(startPos, position));
            return _this.parseCall(name, args, definition, callText);
        });
    };
    SuggestService.prototype.hookCapabilities = function () {
        var definitionProvider = { provideDefinition: this.definitionProvider.bind(this) };
        this.providers.push(vscode.languages.registerDefinitionProvider(filterService_1.default.getRustModeFilter(), definitionProvider));
        var completionProvider = { provideCompletionItems: this.completionProvider.bind(this) };
        this.providers.push((_a = vscode.languages).registerCompletionItemProvider.apply(_a, [filterService_1.default.getRustModeFilter(), completionProvider].concat(['.', ':'])));
        var signatureProvider = { provideSignatureHelp: this.signatureHelpProvider.bind(this) };
        this.providers.push((_b = vscode.languages).registerSignatureHelpProvider.apply(_b, [filterService_1.default.getRustModeFilter(), signatureProvider].concat(['(', ','])));
        var hoverProvider = { provideHover: this.hoverProvider.bind(this) };
        this.providers.push(vscode.languages.registerHoverProvider(filterService_1.default.getRustModeFilter(), hoverProvider));
        var _a, _b;
    };
    SuggestService.prototype.dataHandler = function (data) {
        var lines = data.toString().split(/\r?\n/);
        for (var _i = 0, lines_3 = lines; _i < lines_3.length; _i++) {
            var line = lines_3[_i];
            if (line.length === 0) {
                continue;
            }
            else if (line.startsWith('END')) {
                var callback = this.commandCallbacks.shift();
                callback(this.linesBuffer);
                this.linesBuffer = [];
            }
            else {
                this.linesBuffer.push(line);
            }
        }
    };
    SuggestService.prototype.updateTmpFile = function (document) {
        fs.writeFileSync(this.tmpFile, document.getText());
    };
    SuggestService.prototype.runCommand = function (document, command, args) {
        var _this = this;
        this.updateTmpFile(document);
        var queryString = [command].concat(args).join('\t') + '\n';
        this.lastCommand = queryString;
        var promise = new Promise(function (resolve) {
            _this.commandCallbacks.push(resolve);
        });
        this.racerDaemon.stdin.write(queryString);
        return promise;
    };
    return SuggestService;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = SuggestService;
//# sourceMappingURL=suggestService.js.map