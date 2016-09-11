var vscode = require('vscode');
var rustFormat_1 = require('./rustFormat');
var rustMode_1 = require('./rustMode');
var rustStatus_1 = require('./rustStatus');
var racerClient_1 = require('./racerClient');
var diagnosticCollection;
function activate(ctx) {
    console.log('Rusty Code activated');
    var rustConfig = vscode.workspace.getConfiguration('rust');
    diagnosticCollection = vscode.languages.createDiagnosticCollection('rust');
    var config = vscode.workspace.getConfiguration('rust');
    var client = new racerClient_1.RacerClient(config).start();
    ctx.subscriptions.push(client);
    ctx.subscriptions.push(vscode.languages.registerDocumentFormattingEditProvider(rustMode_1.RUST_MODE, new rustFormat_1.FormatService()));
    ctx.subscriptions.push(diagnosticCollection);
    ctx.subscriptions.push(vscode.window.onDidChangeActiveTextEditor(rustStatus_1.showHideStatus));
    ctx.subscriptions.push(vscode.workspace.onDidSaveTextDocument(function (document) {
        if (!rustConfig['formatOnSave'])
            return;
        vscode.commands.executeCommand("editor.action.format");
    }));
}
exports.activate = activate;
//# sourceMappingURL=rustMain.js.map