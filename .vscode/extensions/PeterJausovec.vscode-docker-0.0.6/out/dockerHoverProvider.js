/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
var parser = require('./parser');
var suggestHelper = require('./helpers/suggestSupportHelper');
var DockerHoverProvider = (function () {
    // Provide the parser you want to use as well as keyinfo dictionary.
    function DockerHoverProvider(wordParser, keyInfo) {
        this._parser = wordParser;
        this._keyInfo = keyInfo;
    }
    DockerHoverProvider.prototype.provideHover = function (document, position, token) {
        var line = document.lineAt(position.line);
        if (line.text.length === 0) {
            return Promise.resolve(null);
        }
        var tokens = this._parser.parseLine(line);
        return this._computeInfoForLineWithTokens(line.text, tokens, position);
    };
    DockerHoverProvider.prototype._computeInfoForLineWithTokens = function (line, tokens, position) {
        var _this = this;
        var possibleTokens = this._parser.tokensAtColumn(tokens, position.character);
        return Promise.all(possibleTokens.map(function (tokenIndex) { return _this._computeInfoForToken(line, tokens, tokenIndex); })).then(function (results) {
            return possibleTokens.map(function (tokenIndex, arrayIndex) {
                return {
                    startIndex: tokens[tokenIndex].startIndex,
                    endIndex: tokens[tokenIndex].endIndex,
                    result: results[arrayIndex]
                };
            });
        }).then(function (results) {
            var r = results.filter(function (r) { return !!r.result; });
            if (r.length === 0) {
                return null;
            }
            var range = new vscode_1.Range(position.line, r[0].startIndex, position.line, r[0].endIndex);
            r[0].result.then(function (t) {
                var hover = new vscode_1.Hover(t, range);
                return hover;
            });
        });
    };
    DockerHoverProvider.prototype._computeInfoForToken = function (line, tokens, tokenIndex) {
        // -------------
        // Detect hovering on a key
        if (tokens[tokenIndex].type === parser.TokenType.Key) {
            var keyName = this._parser.keyNameFromKeyToken(this._parser.tokenValue(line, tokens[tokenIndex])).trim();
            var r = this._keyInfo[keyName];
            if (r) {
                return Promise.resolve([r]);
            }
        }
        // -------------
        // Detect <<image: [["something"]]>>
        // Detect <<image: [[something]]>>
        var helper = new suggestHelper.SuggestSupportHelper();
        var r2 = helper.getImageNameHover(line, this._parser, tokens, tokenIndex);
        if (r2) {
            return r2;
        }
        return null;
    };
    return DockerHoverProvider;
}());
exports.DockerHoverProvider = DockerHoverProvider;
//# sourceMappingURL=dockerHoverProvider.js.map