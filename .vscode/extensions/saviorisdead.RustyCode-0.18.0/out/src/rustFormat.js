var vscode = require('vscode');
var cp = require('child_process');
var pathService_1 = require('./pathService');
function formatRustfmtCommand(fileName, writeMode) {
    return pathService_1.PathService.getRustfmtPath() + ' --write-mode=' + writeMode + ' ' + fileName;
}
var FormatService = (function () {
    function FormatService() {
        this.writeMode = 'display';
        this.writeMode = 'display';
    }
    FormatService.prototype.provideDocumentFormattingEdits = function (document) {
        var _this = this;
        return document.save().then(function () {
            return _this.performFormatFile(document, _this.writeMode);
        });
    };
    FormatService.prototype.performFormatFile = function (document, writeMode) {
        return new Promise(function (resolve, reject) {
            var fileName = document.fileName;
            var command = formatRustfmtCommand(fileName, writeMode);
            cp.exec(command, function (err, stdout, stderr) {
                try {
                    if (err && err.code == 'ENOENT') {
                        vscode.window.showInformationMessage('The "rustfmt" command is not available. Make sure it is installed.');
                        return resolve(null);
                    }
                    if (err)
                        return reject('Cannot format due to syntax errors');
                    // Need this to remove label of rustfmt output
                    var text = stdout.toString().split('\n').slice(2).join('\n');
                    //TODO: implement parsing of rustfmt output with 'diff' writemode
                    var lastLine = document.lineCount;
                    var lastLineLastCol = document.lineAt(lastLine - 1).range.end.character;
                    var range = new vscode.Range(0, 0, lastLine - 1, lastLineLastCol);
                    return resolve([new vscode.TextEdit(range, text)]);
                }
                catch (e) {
                    reject(e);
                }
            });
        });
    };
    return FormatService;
})();
exports.FormatService = FormatService;
//# sourceMappingURL=rustFormat.js.map