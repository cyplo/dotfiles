"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var vscode_1 = require('vscode');
var vscode_2 = require('vscode');
var withExtension = vscode_2.workspace.getConfiguration('path-intellisense')['extensionOnImport'];
var PathCompletionItem = (function (_super) {
    __extends(PathCompletionItem, _super);
    function PathCompletionItem(fileInfo, isImport, documentExtension) {
        _super.call(this, fileInfo.file);
        this.kind = vscode_1.CompletionItemKind.File;
        this.addGroupByFolderFile(fileInfo);
        this.removeExtension(fileInfo, isImport, documentExtension);
        this.addSlashForFolder(fileInfo);
    }
    PathCompletionItem.prototype.addGroupByFolderFile = function (fileInfo) {
        this.sortText = (fileInfo.isFile ? 'b' : 'a') + "_" + fileInfo.file;
    };
    PathCompletionItem.prototype.addSlashForFolder = function (fileInfo) {
        if (!fileInfo.isFile) {
            this.label = fileInfo.file + "/";
            this.insertText = fileInfo.file;
        }
    };
    PathCompletionItem.prototype.removeExtension = function (fileInfo, isImport, documentExtension) {
        if (!fileInfo.isFile || withExtension || !isImport) {
            return;
        }
        var fragments = fileInfo.file.split('.');
        var extension = fragments[fragments.length - 1];
        if (extension !== documentExtension) {
            return;
        }
        var index = fileInfo.file.lastIndexOf('.');
        this.insertText = index != -1 ? fileInfo.file.substring(0, index) : fileInfo.file;
    };
    return PathCompletionItem;
}(vscode_1.CompletionItem));
exports.PathCompletionItem = PathCompletionItem;
//# sourceMappingURL=PathCompletionItem.js.map