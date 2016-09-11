"use strict";
var vscode = require('vscode');
var rustSymbols_1 = require('../rustSymbols');
var pathService_1 = require('./pathService');
var WorkspaceSymbolService = (function () {
    function WorkspaceSymbolService() {
    }
    WorkspaceSymbolService.prototype.provideWorkspaceSymbols = function (query /*, token: vscode.CancellationToken*/) {
        return new Promise(function (resolve, reject) {
            pathService_1.default.cwd().then(function (value) {
                if (typeof value === 'string') {
                    return resolve(rustSymbols_1.populateWorkspaceSymbols(value, query));
                }
                else {
                    vscode.window.showErrorMessage(value.message);
                    return reject(value.message);
                }
            });
        });
    };
    return WorkspaceSymbolService;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = WorkspaceSymbolService;
//# sourceMappingURL=workspaceSymbolService.js.map