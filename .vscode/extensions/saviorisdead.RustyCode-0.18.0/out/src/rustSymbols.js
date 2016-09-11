"use strict";
var vscode = require('vscode');
var cp = require('child_process');
var pathService_1 = require('./services/pathService');
var rustKindToCodeKind = {
    'struct': vscode.SymbolKind.Class,
    'method': vscode.SymbolKind.Method,
    'field': vscode.SymbolKind.Field,
    'function': vscode.SymbolKind.Function,
    'constant': vscode.SymbolKind.Constant,
    'static': vscode.SymbolKind.Constant,
    'enum': vscode.SymbolKind.Enum,
    // Don't really like this, but this was the best alternative given the absense of vscode.SymbolKind.Macro
    'macro': vscode.SymbolKind.Function
};
function getSymbolKind(kind) {
    var symbolKind;
    if (kind !== '') {
        symbolKind = rustKindToCodeKind[kind];
    }
    return symbolKind;
}
function resultToSymbols(json) {
    var decls = JSON.parse(json);
    var symbols = [];
    decls.forEach(function (decl) {
        var pos = new vscode.Position(decl.line - 1, 0);
        var kind = getSymbolKind(decl.kind);
        var symbol = new vscode.SymbolInformation(decl.name, kind, new vscode.Range(pos, pos), vscode.Uri.file(decl.path), decl.container);
        symbols.push(symbol);
    });
    return symbols;
}
function populateDocumentSymbols(documentPath) {
    return new Promise(function (resolve, reject) {
        cp.execFile(pathService_1.default.getRustsymPath(), ['search', '-l', documentPath], {}, function (err, stdout /*, stderr*/) {
            try {
                if (err && err.code === 'ENOENT') {
                    vscode.window.showInformationMessage('The "rustsym" command is not available. Make sure it is installed.');
                    return resolve([]);
                }
                var result = stdout.toString();
                var symbols = resultToSymbols(result);
                return resolve(symbols);
            }
            catch (e) {
                reject(e);
            }
        });
    });
}
exports.populateDocumentSymbols = populateDocumentSymbols;
function populateWorkspaceSymbols(workspaceRoot, query) {
    return new Promise(function (resolve, reject) {
        cp.execFile(pathService_1.default.getRustsymPath(), ['search', '-g', workspaceRoot, query], { maxBuffer: 1024 * 1024 }, function (err, stdout /*, stderr*/) {
            try {
                if (err && err.code === 'ENOENT') {
                    vscode.window.showInformationMessage('The "rustsym" command is not available. Make sure it is installed.');
                    return resolve([]);
                }
                var result = stdout.toString();
                var symbols = resultToSymbols(result);
                return resolve(symbols);
            }
            catch (e) {
                reject(e);
            }
        });
    });
}
exports.populateWorkspaceSymbols = populateWorkspaceSymbols;
//# sourceMappingURL=rustSymbols.js.map