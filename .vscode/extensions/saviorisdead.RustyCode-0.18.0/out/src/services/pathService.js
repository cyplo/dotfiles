"use strict";
var vscode = require('vscode');
var findUp = require('find-up');
var path = require('path');
var PathService = (function () {
    function PathService() {
    }
    PathService.getRacerPath = function () {
        var racerPath = vscode.workspace.getConfiguration('rust')['racerPath'];
        return racerPath || 'racer';
    };
    PathService.getRustfmtPath = function () {
        var rusfmtPath = vscode.workspace.getConfiguration('rust')['rustfmtPath'];
        return rusfmtPath || 'rustfmt';
    };
    PathService.getRustsymPath = function () {
        var rustsymPath = vscode.workspace.getConfiguration('rust')['rustsymPath'];
        return rustsymPath || 'rustsym';
    };
    PathService.getRustLangSrcPath = function () {
        var rustSrcPath = vscode.workspace.getConfiguration('rust')['rustLangSrcPath'];
        return rustSrcPath || '';
    };
    PathService.getCargoPath = function () {
        var cargoPath = vscode.workspace.getConfiguration('rust')['cargoPath'];
        return cargoPath || 'cargo';
    };
    PathService.getCargoHomePath = function () {
        var cargoHomePath = vscode.workspace.getConfiguration('rust')['cargoHomePath'];
        return cargoHomePath || process.env['CARGO_HOME'] || '';
    };
    PathService.cwd = function () {
        if (vscode.window.activeTextEditor === null) {
            return Promise.resolve(new Error('No active document'));
        }
        else {
            var fileName = vscode.window.activeTextEditor.document.fileName;
            if (!fileName.startsWith(vscode.workspace.rootPath)) {
                return Promise.resolve(new Error('Current document not in the workspace'));
            }
            return findUp('Cargo.toml', { cwd: path.dirname(fileName) }).then(function (value) {
                if (value === null) {
                    return new Error('There is no Cargo.toml near active document');
                }
                else {
                    return path.dirname(value);
                }
            });
        }
    };
    return PathService;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PathService;
//# sourceMappingURL=pathService.js.map