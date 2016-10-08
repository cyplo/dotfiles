var vscode = require('vscode');
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
    PathService.getRustLangSrcPath = function () {
        return vscode.workspace.getConfiguration('rust')['rustLangSrcPath'];
    };
    return PathService;
})();
exports.PathService = PathService;
//# sourceMappingURL=pathService.js.map