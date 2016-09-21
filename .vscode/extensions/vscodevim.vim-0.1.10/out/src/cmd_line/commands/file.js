"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
const vscode = require("vscode");
const path = require("path");
const node = require("../node");
(function (FilePosition) {
    FilePosition[FilePosition["CurrentWindow"] = 0] = "CurrentWindow";
    FilePosition[FilePosition["NewWindow"] = 1] = "NewWindow";
})(exports.FilePosition || (exports.FilePosition = {}));
var FilePosition = exports.FilePosition;
class FileCommand extends node.CommandBase {
    constructor(args) {
        super();
        this._name = 'file';
        this._shortName = 'file';
        this._arguments = args;
    }
    get arguments() {
        return this._arguments;
    }
    getActiveViewColumn() {
        const active = vscode.window.activeTextEditor;
        if (!active) {
            return vscode.ViewColumn.One;
        }
        return active.viewColumn;
    }
    getViewColumnToRight() {
        const active = vscode.window.activeTextEditor;
        if (!active) {
            return vscode.ViewColumn.One;
        }
        switch (active.viewColumn) {
            case vscode.ViewColumn.One:
                return vscode.ViewColumn.Two;
            case vscode.ViewColumn.Two:
                return vscode.ViewColumn.Three;
        }
        return active.viewColumn;
    }
    execute() {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this._arguments.name) {
                // Open an empty file
                if (this._arguments.position === FilePosition.CurrentWindow) {
                    yield vscode.commands.executeCommand("workbench.action.files.newUntitledFile");
                }
                else {
                    yield vscode.commands.executeCommand("workbench.action.splitEditor");
                    yield vscode.commands.executeCommand("workbench.action.files.newUntitledFile");
                    yield vscode.commands.executeCommand("workbench.action.closeOtherEditors");
                }
                return;
            }
            let currentFilePath = vscode.window.activeTextEditor.document.uri.path;
            let newFilePath = path.join(path.dirname(currentFilePath), this._arguments.name);
            if (newFilePath !== currentFilePath) {
                let folder = vscode.Uri.file(newFilePath);
                yield vscode.commands.executeCommand("vscode.open", folder, this._arguments.position === FilePosition.NewWindow ? this.getViewColumnToRight() : this.getActiveViewColumn());
            }
        });
    }
}
exports.FileCommand = FileCommand;
//# sourceMappingURL=file.js.map