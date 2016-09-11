"use strict";
var vscode = require('vscode');
var cp = require('child_process');
var fs = require('fs');
var pathService_1 = require('./pathService');
var ansiRegex = /[\u001b\u009b][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]/g;
var FormatService = (function () {
    function FormatService() {
    }
    FormatService.prototype.cleanDiffLine = function (line) {
        if (line.endsWith('\u23CE')) {
            return line.slice(1, -1) + '\n';
        }
        return line.slice(1);
    };
    FormatService.prototype.stripColorCodes = function (input) {
        return input.replace(ansiRegex, '');
    };
    FormatService.prototype.parseDiff = function (fileToProcess, diff) {
        var patches = [];
        var currentPatch;
        var currentFile;
        diff = this.stripColorCodes(diff);
        for (var _i = 0, _a = diff.split(/\n/); _i < _a.length; _i++) {
            var line = _a[_i];
            if (line.startsWith('Diff of')) {
                currentFile = vscode.Uri.file(line.slice('Diff of '.length, -1));
            }
            if (!currentFile) {
                continue;
            }
            if (currentFile.toString() === fileToProcess.toString() + '.fmt') {
                if (line.startsWith('Diff at line')) {
                    if (currentPatch != null) {
                        patches.push(currentPatch);
                    }
                    currentPatch = {
                        startLine: parseInt(line.slice('Diff at line'.length), 10),
                        newLines: [],
                        removedLines: 0
                    };
                }
                else if (line.startsWith('+')) {
                    currentPatch.newLines.push(this.cleanDiffLine(line));
                }
                else if (line.startsWith('-')) {
                    currentPatch.removedLines += 1;
                }
                else if (line.startsWith(' ')) {
                    currentPatch.newLines.push(this.cleanDiffLine(line));
                    currentPatch.removedLines += 1;
                }
            }
        }
        if (currentPatch) {
            patches.push(currentPatch);
        }
        var cummulativeOffset = 0;
        var textEdits = patches.map(function (patch) {
            var newLines = patch.newLines;
            var removedLines = patch.removedLines;
            var startLine = patch.startLine - 1 + cummulativeOffset;
            var endLine = removedLines === 0 ? startLine : startLine + removedLines - 1;
            var range = new vscode.Range(startLine, 0, endLine, Number.MAX_SAFE_INTEGER);
            cummulativeOffset += (removedLines - newLines.length);
            var lastLineIndex = newLines.length - 1;
            newLines[lastLineIndex] = newLines[lastLineIndex].replace('\n', '');
            return vscode.TextEdit.replace(range, newLines.join(''));
        });
        return textEdits;
    };
    FormatService.prototype.provideDocumentFormattingEdits = function (document) {
        var _this = this;
        return new Promise(function (resolve, reject) {
            var fileName = document.fileName + '.fmt';
            fs.writeFileSync(fileName, document.getText());
            var args = ['--skip-children', '--write-mode=diff', fileName];
            var env = Object.assign({ TERM: 'xterm' }, process.env);
            cp.execFile(pathService_1.default.getRustfmtPath(), args, { env: env }, function (err, stdout, stderr) {
                try {
                    if (err && err.code === 'ENOENT') {
                        vscode.window.showInformationMessage('The "rustfmt" command is not available. Make sure it is installed.');
                        return resolve([]);
                    }
                    // rustfmt will return with exit code 3 when it encounters code that could not
                    // be automatically formatted. However, it will continue to format the rest of the file.
                    // New releases will return exit code 4 when the write mode is diff and a valid diff is provided.
                    // For these reasons, if the exit code is 1 or 2, then it should be treated as an error.
                    var hasFatalError = (err && err.code < 3);
                    // If an error is encountered with any other exit code, inform the user of the error.
                    if ((err || stderr.length) && hasFatalError) {
                        vscode.window.setStatusBarMessage('$(alert) Cannot format due to syntax errors', 5000);
                        return reject();
                    }
                    return resolve(_this.parseDiff(document.uri, stdout));
                }
                catch (e) {
                    reject(e);
                }
                finally {
                    fs.unlinkSync(fileName);
                }
            });
        });
    };
    return FormatService;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = FormatService;
//# sourceMappingURL=formatService.js.map