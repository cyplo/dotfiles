'use strict';
var vscode = require('vscode');
var cp = require('child_process');
var pathService_1 = require('./services/pathService');
function vsCodeKindFromRacerType(racerType) {
    switch (racerType) {
        case 'Function':
            return vscode.CompletionItemKind.Function;
        case 'Impl':
        case 'Struct':
            return vscode.CompletionItemKind.Class;
        case 'Type':
            return vscode.CompletionItemKind.Keyword;
        case 'Trait':
            return vscode.CompletionItemKind.Interface;
        case 'Enum':
            return vscode.CompletionItemKind.Enum;
        case 'StructField':
        case 'EnumVariant':
            return vscode.CompletionItemKind.Field;
        case 'Let':
        case 'IfLet':
        case 'WhileLet':
        case 'For':
        case 'Const':
        case 'Static':
        case 'MatchArm':
            return vscode.CompletionItemKind.Variable;
        case 'Module':
        case 'Crate':
            return vscode.CompletionItemKind.Module;
    }
    return vscode.CompletionItemKind.Variable;
}
function parseRacerResult(racerOutput) {
    var lines = racerOutput.replace('END', '').split('MATCH').map(function (line) { return line.trim(); }).slice(1);
    if (lines.length <= 0)
        return [];
    var suggestions = lines.map(function (line) {
        var lineItems = line.trim().split(';');
        var suggestion = new vscode.CompletionItem(lineItems[0]);
        suggestion.kind = vsCodeKindFromRacerType(lineItems[5]);
        suggestion.insertText = lineItems[1];
        suggestion.detail = lineItems[6];
        return suggestion;
    });
    return suggestions;
}
function formatRacerCommand(args) {
    var setEnv;
    if (process.platform === 'win32')
        setEnv = 'SET RUST_SRC_PATH=' + pathService_1.PathService.getRustLangSrcPath() + '&&';
    else
        setEnv = 'RUST_SRC_PATH=' + pathService_1.PathService.getRustLangSrcPath();
    return setEnv + ' ' + pathService_1.PathService.getRacerPath() + ' ' + args.join(' ');
}
var RustCompletionItemProvider = (function () {
    function RustCompletionItemProvider() {
    }
    RustCompletionItemProvider.prototype.provideCompletionItems = function (document, position, token) {
        return new Promise(function (resolve, reject) {
            var fileName = document.fileName;
            // Line number in vsCode is zero-based and in racer not
            var lineNumber = (position.line + 1).toString();
            var characterNumber = position.character.toString();
            var args = ['complete-with-snippet', lineNumber, characterNumber, fileName];
            var command = formatRacerCommand(args);
            var p = cp.exec(command, function (err, stdout, stderr) {
                try {
                    if (err && err.code == 'ENOENT') {
                        vscode.window.showInformationMessage('The "racer" command is not available');
                    }
                    if (err)
                        return reject(err);
                    var suggestions = parseRacerResult(stdout.toString());
                    resolve(suggestions);
                }
                catch (e) {
                    reject(e);
                }
            });
        });
    };
    return RustCompletionItemProvider;
})();
exports.RustCompletionItemProvider = RustCompletionItemProvider;
//# sourceMappingURL=rustSuggest.js.map