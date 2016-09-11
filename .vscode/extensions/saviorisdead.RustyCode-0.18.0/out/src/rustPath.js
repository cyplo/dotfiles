var vscode = require('vscode');
function getRustLangSrcPath() {
    return vscode.workspace.getConfiguration('rust')['rustLangSrcPath'];
}
exports.getRustLangSrcPath = getRustLangSrcPath;
function getRacerPath() {
    var racerPath = vscode.workspace.getConfiguration('rust')['racerPath'];
    if (racerPath.length > 0)
        return racerPath;
    return 'racer';
}
exports.getRacerPath = getRacerPath;
function getRustfmtPath() {
    var rusfmtPath = vscode.workspace.getConfiguration('rust')['rustfmtPath'];
    if (rusfmtPath.length > 0)
        return rusfmtPath;
    return 'rustfmt';
}
exports.getRustfmtPath = getRustfmtPath;
//# sourceMappingURL=rustPath.js.map