"use strict";
var rustSymbols_1 = require('../rustSymbols');
var DocumentSymbolProvider = (function () {
    function DocumentSymbolProvider() {
    }
    DocumentSymbolProvider.prototype.provideDocumentSymbols = function (document /*, token: vscode.CancellationToken*/) {
        return rustSymbols_1.populateDocumentSymbols(document.fileName);
    };
    return DocumentSymbolProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DocumentSymbolProvider;
//# sourceMappingURL=documentSymbolService.js.map