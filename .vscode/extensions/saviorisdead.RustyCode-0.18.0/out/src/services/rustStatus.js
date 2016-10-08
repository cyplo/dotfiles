'use strict';
var filterService_1 = require('./filterService');
var vscode = require('vscode');
var StatusBarService = (function () {
    function StatusBarService() {
    }
    StatusBarService.hideStatus = function () {
        this.statusBarEntry.dispose();
    };
    StatusBarService.showStatus = function (message, command, tooltip) {
        this.statusBarEntry = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, Number.MIN_VALUE);
        this.statusBarEntry.text = message;
        this.statusBarEntry.command = command;
        this.statusBarEntry.color = 'yellow';
        this.statusBarEntry.tooltip = tooltip;
        this.statusBarEntry.show();
    };
    StatusBarService.toggleStatus = function () {
        if (!this.statusBarEntry)
            return;
        if (!vscode.window.activeTextEditor) {
            this.statusBarEntry.hide();
            return;
        }
        if (vscode.languages.match(filterService_1.default.getRustModeFilter(), vscode.window.activeTextEditor.document)) {
            this.statusBarEntry.show();
            return;
        }
        this.statusBarEntry.hide();
    };
    return StatusBarService;
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = StatusBarService;
//# sourceMappingURL=rustStatus.js.map