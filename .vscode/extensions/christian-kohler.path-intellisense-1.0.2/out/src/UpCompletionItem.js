"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var vscode_1 = require('vscode');
var UpCompletionItem = (function (_super) {
    __extends(UpCompletionItem, _super);
    function UpCompletionItem() {
        _super.call(this, '..');
        this.kind = vscode_1.CompletionItemKind.File;
    }
    return UpCompletionItem;
}(vscode_1.CompletionItem));
exports.UpCompletionItem = UpCompletionItem;
//# sourceMappingURL=UpCompletionItem.js.map