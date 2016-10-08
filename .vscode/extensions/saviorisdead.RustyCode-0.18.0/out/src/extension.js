"use strict";
var vscode = require('vscode');
var formatService_1 = require('./services/formatService');
var filterService_1 = require('./services/filterService');
var statusBarService_1 = require('./services/statusBarService');
var suggestService_1 = require('./services/suggestService');
var pathService_1 = require('./services/pathService');
var commandService_1 = require('./services/commandService');
var workspaceSymbolService_1 = require('./services/workspaceSymbolService');
var documentSymbolService_1 = require('./services/documentSymbolService');
function activate(ctx) {
    // Set path to Rust language sources
    var rustSrcPath = pathService_1.default.getRustLangSrcPath();
    if (rustSrcPath) {
        process.env['RUST_SRC_PATH'] = rustSrcPath;
    }
    // Initialize suggestion service
    var suggestService = new suggestService_1.default();
    ctx.subscriptions.push(suggestService.start());
    // Initialize format service
    var formatService = new formatService_1.default();
    ctx.subscriptions.push(vscode.languages.registerDocumentFormattingEditProvider(filterService_1.default.getRustModeFilter(), formatService));
    // Initialize symbol provider services
    ctx.subscriptions.push(vscode.languages.registerWorkspaceSymbolProvider(new workspaceSymbolService_1.default()));
    ctx.subscriptions.push(vscode.languages.registerDocumentSymbolProvider(filterService_1.default.getRustModeFilter(), new documentSymbolService_1.default()));
    // Initialize status bar service
    ctx.subscriptions.push(vscode.window.onDidChangeActiveTextEditor(statusBarService_1.default.toggleStatus.bind(statusBarService_1.default)));
    var alreadyAppliedFormatting = new WeakSet();
    ctx.subscriptions.push(vscode.workspace.onDidSaveTextDocument(function (document) {
        if (document.languageId !== 'rust' || !document.fileName.endsWith('.rs') || alreadyAppliedFormatting.has(document)) {
            return;
        }
        var rustConfig = vscode.workspace.getConfiguration('rust');
        var textEditor = vscode.window.activeTextEditor;
        var formatPromise = Promise.resolve();
        // Incredibly ugly hack to work around no presave event
        // based on https://github.com/Microsoft/vscode-go/pull/115/files
        if (rustConfig['formatOnSave'] && textEditor.document === document) {
            formatPromise = formatService.provideDocumentFormattingEdits(document).then(function (edits) {
                return textEditor.edit(function (editBuilder) {
                    edits.forEach(function (edit) { return editBuilder.replace(edit.range, edit.newText); });
                });
            }).then(function () {
                alreadyAppliedFormatting.add(document);
                return document.save();
            }).then(function () {
                alreadyAppliedFormatting.delete(document);
            }, function () {
                // Catch any errors and ignore so that we still trigger
                // the file save.
            });
        }
        if (rustConfig['checkOnSave']) {
            formatPromise.then(function () {
                switch (rustConfig['checkWith']) {
                    case 'clippy':
                        vscode.commands.executeCommand('rust.cargo.clippy');
                        break;
                    case 'build':
                        vscode.commands.executeCommand('rust.cargo.build.debug');
                        break;
                    case 'check-lib':
                        vscode.commands.executeCommand('rust.cargo.check.lib');
                        break;
                    default:
                        vscode.commands.executeCommand('rust.cargo.check');
                }
            });
        }
    }));
    // Make sure we end up at one error format. If multiple are set, then prompt the user on how they want to proceed.
    // Fix (Change their settings) or Ignore (Use JSON as it comes first in the settings)
    // This should run both on activation and when the config changes to ensure we stay in sync with their preference.
    var updateErrorFormatFlags = function () {
        var rustConfig = vscode.workspace.getConfiguration('rust');
        if (rustConfig['useJsonErrors'] === true && rustConfig['useNewErrorFormat'] === true) {
            var ignoreOption_1 = { title: 'Ignore (Use JSON)' };
            var updateSettingsOption_1 = { title: 'Update Settings' };
            vscode.window.showWarningMessage('Note: rust.useJsonErrors and rust.useNewErrorFormat are mutually exclusive with each other. Which would you like to do?', ignoreOption_1, updateSettingsOption_1).then(function (option) {
                // Nothing selected
                if (option == null) {
                    return;
                }
                if (option === ignoreOption_1) {
                    commandService_1.CommandService.errorFormat = commandService_1.ErrorFormat.JSON;
                }
                else if (updateSettingsOption_1) {
                    vscode.commands.executeCommand('workbench.action.openGlobalSettings');
                }
            });
        }
        else {
            commandService_1.CommandService.updateErrorFormat();
        }
    };
    // Watch for configuration changes for ENV
    ctx.subscriptions.push(vscode.workspace.onDidChangeConfiguration(function () {
        updateErrorFormatFlags();
        var rustLangPath = pathService_1.default.getRustLangSrcPath();
        if (process.env['RUST_SRC_PATH'] !== rustLangPath) {
            process.env['RUST_SRC_PATH'] = rustLangPath;
        }
    }));
    updateErrorFormatFlags();
    // Commands
    // Cargo build
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.build.debug', 'build'));
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.build.release', 'build', '--release'));
    ctx.subscriptions.push(commandService_1.CommandService.buildExampleCommand('rust.cargo.build.example.debug', false));
    ctx.subscriptions.push(commandService_1.CommandService.buildExampleCommand('rust.cargo.build.example.release', true));
    ctx.subscriptions.push(commandService_1.CommandService.runExampleCommand('rust.cargo.run.example.debug', false));
    ctx.subscriptions.push(commandService_1.CommandService.runExampleCommand('rust.cargo.run.example.release', true));
    // Cargo run
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.run.debug', 'run'));
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.run.release', 'run', '--release'));
    // Cargo test
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.test.debug', 'test'));
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.test.release', 'test', '--release'));
    // Cargo bench
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.bench', 'bench'));
    // Cargo doc
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.doc', 'doc'));
    // Cargo update
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.update', 'update'));
    // Cargo clean
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.clean', 'clean'));
    // Cargo check
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.check', 'rustc', '--', '-Zno-trans'));
    // Cargo check lib
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.check.lib', 'rustc', '--lib', '--', '-Zno-trans'));
    // Cargo clippy
    ctx.subscriptions.push(commandService_1.CommandService.formatCommand('rust.cargo.clippy', 'clippy'));
    // Racer crash error
    ctx.subscriptions.push(suggestService.racerCrashErrorCommand('rust.racer.showerror'));
    // Cargo terminate
    ctx.subscriptions.push(commandService_1.CommandService.stopCommand('rust.cargo.terminate'));
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map