"use strict";
var vscode = require('vscode');
var cp = require('child_process');
var path = require('path');
var kill = require('tree-kill');
var pathService_1 = require('./pathService');
var errorRegex = /^(.*):(\d+):(\d+):\s+(\d+):(\d+)\s+(warning|error|note|help):\s+(.*)$/;
(function (ErrorFormat) {
    ErrorFormat[ErrorFormat["OldStyle"] = 0] = "OldStyle";
    ErrorFormat[ErrorFormat["NewStyle"] = 1] = "NewStyle";
    ErrorFormat[ErrorFormat["JSON"] = 2] = "JSON";
})(exports.ErrorFormat || (exports.ErrorFormat = {}));
var ErrorFormat = exports.ErrorFormat;
var ChannelWrapper = (function () {
    function ChannelWrapper(channel) {
        this.channel = channel;
    }
    ChannelWrapper.prototype.append = function (task, message) {
        if (task === this.owner) {
            this.channel.append(message);
        }
    };
    ChannelWrapper.prototype.clear = function (task) {
        if (task === this.owner) {
            this.channel.clear();
        }
    };
    ChannelWrapper.prototype.show = function () {
        this.channel.show(true);
    };
    ChannelWrapper.prototype.setOwner = function (owner) {
        this.owner = owner;
    };
    return ChannelWrapper;
}());
var CargoTask = (function () {
    function CargoTask(args, channel) {
        this.arguments = args;
        this.channel = channel;
        this.interrupted = false;
    }
    CargoTask.prototype.execute = function (cwd) {
        var _this = this;
        return new Promise(function (resolve, reject) {
            var cargoPath = pathService_1.default.getCargoPath();
            var startTime = Date.now();
            var task = 'cargo ' + _this.arguments.join(' ');
            var errorFormat = CommandService.errorFormat;
            var output = '';
            _this.channel.clear(_this);
            _this.channel.append(_this, "Running \"" + task + "\":\n");
            var newEnv = Object.assign({}, process.env);
            if (errorFormat === ErrorFormat.JSON) {
                newEnv['RUSTFLAGS'] = '-Zunstable-options --error-format=json';
            }
            else if (errorFormat === ErrorFormat.NewStyle) {
                newEnv['RUST_NEW_ERROR_FORMAT'] = 'true';
            }
            _this.process = cp.spawn(cargoPath, _this.arguments, { cwd: cwd, env: newEnv });
            _this.process.stdout.on('data', function (data) {
                _this.channel.append(_this, data.toString());
            });
            _this.process.stderr.on('data', function (data) {
                output += data.toString();
                // If the user has selected JSON errors, we defer the output to process exit
                // to allow us to parse the errors into something human readable.
                // Otherwise we just emit the output as-is.
                if (errorFormat !== ErrorFormat.JSON) {
                    _this.channel.append(_this, data.toString());
                }
            });
            _this.process.on('error', function (error) {
                if (error.code === 'ENOENT') {
                    vscode.window.showInformationMessage('The "cargo" command is not available. Make sure it is installed.');
                }
            });
            _this.process.on('exit', function (code) {
                _this.process.removeAllListeners();
                _this.process = null;
                // If the user has selected JSON errors, we need to parse and print them into something human readable
                // It might not match Rust 1-to-1, but its better than JSON
                if (errorFormat === ErrorFormat.JSON) {
                    for (var _i = 0, _a = output.split('\n'); _i < _a.length; _i++) {
                        var line = _a[_i];
                        // Catch any JSON lines
                        if (line.startsWith('{')) {
                            var errors = [];
                            if (CommandService.parseJsonLine(errors, line)) {
                                /* tslint:disable:max-line-length */
                                // Print any errors as best we can match to Rust's format.
                                // TODO: Add support for child errors/text highlights.
                                // TODO: The following line will currently be printed fine, but the two lines after will not.
                                // src\main.rs:5:5: 5:8 error: expected one of `!`, `.`, `::`, `;`, `?`, `{`, `}`, or an operator, found `let`
                                // src\main.rs:5     let mut a = 4;
                                //                   ^~~
                                /* tslint:enable:max-line-length */
                                for (var _b = 0, errors_1 = errors; _b < errors_1.length; _b++) {
                                    var error = errors_1[_b];
                                    _this.channel.append(_this, (error.filename + ":" + error.startLine + ":" + error.startCharacter + ":") +
                                        (" " + error.endLine + ":" + error.endCharacter + " " + error.severity + ": " + error.message + "\n"));
                                }
                            }
                        }
                        else {
                            // Catch any non-JSON lines like "Compiling <project> (<path>)"
                            _this.channel.append(_this, line + "\n");
                        }
                    }
                }
                var endTime = Date.now();
                _this.channel.append(_this, "\n\"" + task + "\" completed with code " + code);
                _this.channel.append(_this, "\nIt took approximately " + (endTime - startTime) / 1000 + " seconds");
                if (code === 0 || _this.interrupted) {
                    resolve(_this.interrupted ? '' : output);
                }
                else {
                    if (code !== 101) {
                        vscode.window.showWarningMessage("Cargo unexpectedly stopped with code " + code);
                    }
                    reject(output);
                }
            });
        });
    };
    CargoTask.prototype.kill = function () {
        var _this = this;
        return new Promise(function (resolve) {
            if (!_this.interrupted && _this.process) {
                kill(_this.process.pid, 'SIGINT', resolve);
                _this.interrupted = true;
            }
        });
    };
    return CargoTask;
}());
var CommandService = (function () {
    function CommandService() {
    }
    CommandService.formatCommand = function (commandName) {
        var _this = this;
        var args = [];
        for (var _i = 1; _i < arguments.length; _i++) {
            args[_i - 1] = arguments[_i];
        }
        return vscode.commands.registerCommand(commandName, function () {
            _this.runCargo(args, true, true);
        });
    };
    CommandService.buildExampleCommand = function (commandName, release) {
        var _this = this;
        return vscode.commands.registerCommand(commandName, function () {
            _this.buildExample(release);
        });
    };
    CommandService.runExampleCommand = function (commandName, release) {
        var _this = this;
        return vscode.commands.registerCommand(commandName, function () {
            _this.runExample(release);
        });
    };
    CommandService.stopCommand = function (commandName) {
        var _this = this;
        return vscode.commands.registerCommand(commandName, function () {
            if (_this.currentTask) {
                _this.currentTask.kill();
            }
        });
    };
    CommandService.updateErrorFormat = function () {
        var config = vscode.workspace.getConfiguration('rust');
        if (config['useJsonErrors'] === true) {
            this.errorFormat = ErrorFormat.JSON;
        }
        else if (config['useNewErrorFormat'] === true) {
            this.errorFormat = ErrorFormat.NewStyle;
        }
        else {
            this.errorFormat = ErrorFormat.OldStyle;
        }
    };
    CommandService.determineExampleName = function () {
        var showDocumentIsNotExampleWarning = function () {
            vscode.window.showWarningMessage('Current document is not an example');
        };
        var filePath = vscode.window.activeTextEditor.document.uri.fsPath;
        var dir = path.basename(path.dirname(filePath));
        if (dir !== 'examples') {
            showDocumentIsNotExampleWarning();
            return '';
        }
        var filename = path.basename(filePath);
        if (!filename.endsWith('.rs')) {
            showDocumentIsNotExampleWarning();
            return '';
        }
        return path.basename(filename, '.rs');
    };
    CommandService.buildExample = function (release) {
        var exampleName = this.determineExampleName();
        if (exampleName.length === 0) {
            return;
        }
        var args = ['build', '--example', exampleName];
        if (release) {
            args.push('--release');
        }
        this.runCargo(args, true, true);
    };
    CommandService.runExample = function (release) {
        var exampleName = this.determineExampleName();
        if (exampleName.length === 0) {
            return;
        }
        var args = ['run', '--example', exampleName];
        if (release) {
            args.push('--release');
        }
        this.runCargo(args, true, true);
    };
    CommandService.parseDiagnostics = function (cwd, output) {
        var _this = this;
        var errors = [];
        // The new Rust error format is a little more complex and is spread out over
        // multiple lines. For this case, we'll just use a global regex to get our matches
        if (this.errorFormat === ErrorFormat.NewStyle) {
            this.parseNewHumanReadable(errors, output);
        }
        else {
            // Otherwise, parse out the errors line by line.
            for (var _i = 0, _a = output.split('\n'); _i < _a.length; _i++) {
                var line = _a[_i];
                if (this.errorFormat === ErrorFormat.JSON && line.startsWith('{')) {
                    this.parseJsonLine(errors, line);
                }
                else {
                    this.parseOldHumanReadable(errors, line);
                }
            }
        }
        var mapSeverityToVsCode = function (severity) {
            if (severity === 'warning') {
                return vscode.DiagnosticSeverity.Warning;
            }
            else if (severity === 'error') {
                return vscode.DiagnosticSeverity.Error;
            }
            else if (severity === 'note') {
                return vscode.DiagnosticSeverity.Information;
            }
            else if (severity === 'help') {
                return vscode.DiagnosticSeverity.Hint;
            }
            else {
                return vscode.DiagnosticSeverity.Error;
            }
        };
        this.diagnostics.clear();
        var diagnosticMap = new Map();
        errors.forEach(function (error) {
            var filePath = path.join(cwd, error.filename);
            // VSCode starts its lines and columns at 0, so subtract 1 off 
            var range = new vscode.Range(error.startLine - 1, error.startCharacter - 1, error.endLine - 1, error.endCharacter - 1);
            var severity = mapSeverityToVsCode(error.severity);
            var diagnostic = new vscode.Diagnostic(range, error.message, severity);
            var diagnostics = diagnosticMap.get(filePath);
            if (!diagnostics) {
                diagnostics = [];
            }
            diagnostics.push(diagnostic);
            diagnosticMap.set(filePath, diagnostics);
        });
        diagnosticMap.forEach(function (diags, uri) {
            _this.diagnostics.set(vscode.Uri.file(uri), diags);
        });
    };
    CommandService.parseOldHumanReadable = function (errors, line) {
        var match = line.match(errorRegex);
        if (match) {
            var filename = match[1];
            if (!errors[filename]) {
                errors[filename] = [];
            }
            errors.push({
                filename: filename,
                startLine: Number(match[2]),
                startCharacter: Number(match[3]),
                endLine: Number(match[4]),
                endCharacter: Number(match[5]),
                severity: match[6],
                message: match[7]
            });
        }
    };
    CommandService.parseNewHumanReadable = function (errors, output) {
        var newErrorRegex = /(warning|error|note|help)(?:\[(.*)\])?\: (.*)\n\s+-->\s+(.*):(\d+):(\d+)/g;
        while (true) {
            var match = newErrorRegex.exec(output);
            if (match == null) {
                break;
            }
            var filename = match[4];
            if (!errors[filename]) {
                errors[filename] = [];
            }
            var startLine = Number(match[5]);
            var startCharacter = Number(match[6]);
            errors.push({
                filename: filename,
                startLine: startLine,
                startCharacter: startCharacter,
                endLine: startLine,
                endCharacter: startCharacter,
                severity: match[1],
                message: match[3]
            });
        }
    };
    ;
    CommandService.parseJsonLine = function (errors, line) {
        var errorJson = JSON.parse(line);
        return this.parseJson(errors, errorJson);
    };
    CommandService.parseJson = function (errors, errorJson) {
        var spans = errorJson.spans;
        if (spans.length === 0) {
            return false;
        }
        for (var _i = 0, _a = errorJson.spans; _i < _a.length; _i++) {
            var span = _a[_i];
            // Only add the primary span, as VSCode orders the problem window by the 
            // error's range, which causes a lot of confusion if there are duplicate messages.
            if (span.is_primary) {
                var error = {
                    filename: span.file_name,
                    startLine: span.line_start,
                    startCharacter: span.column_start,
                    endLine: span.line_end,
                    endCharacter: span.column_end,
                    severity: errorJson.level,
                    message: errorJson.message
                };
                errors.push(error);
            }
        }
        return true;
    };
    CommandService.runCargo = function (args, force, visible) {
        var _this = this;
        if (force === void 0) { force = false; }
        if (visible === void 0) { visible = false; }
        if (force && this.currentTask) {
            this.channel.setOwner(null);
            this.currentTask.kill().then(function () {
                _this.runCargo(args, force, visible);
            });
            return;
        }
        else if (this.currentTask) {
            return;
        }
        this.currentTask = new CargoTask(args, this.channel);
        if (visible) {
            this.channel.setOwner(this.currentTask);
            this.channel.show();
        }
        pathService_1.default.cwd().then(function (value) {
            if (typeof value === 'string') {
                _this.currentTask.execute(value).then(function (output) {
                    _this.parseDiagnostics(value, output);
                }, function (output) {
                    _this.parseDiagnostics(value, output);
                }).then(function () {
                    _this.currentTask = null;
                });
            }
            else {
                vscode.window.showErrorMessage(value.message);
            }
        });
    };
    CommandService.diagnostics = vscode.languages.createDiagnosticCollection('rust');
    CommandService.channel = new ChannelWrapper(vscode.window.createOutputChannel('Cargo'));
    return CommandService;
}());
exports.CommandService = CommandService;
//# sourceMappingURL=commandService.js.map