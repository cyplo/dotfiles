/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var Parser = (function () {
    function Parser(parseTokenRegex) {
        this._tokenParseRegex = parseTokenRegex;
    }
    Parser.prototype.keyNameFromKeyToken = function (keyToken) {
        return keyToken.replace(this._tokenParseRegex, '');
    };
    Parser.prototype.tokenValue = function (line, token) {
        return line.substring(token.startIndex, token.endIndex);
    };
    Parser.prototype.tokensAtColumn = function (tokens, charIndex) {
        for (var i = 0, len = tokens.length; i < len; i++) {
            var token = tokens[i];
            if (token.endIndex < charIndex) {
                continue;
            }
            if (token.endIndex === charIndex && i + 1 < len) {
                return [i, i + 1];
            }
            return [i];
        }
        // should not happen: no token found? => return the last one
        return [tokens.length - 1];
    };
    return Parser;
}());
exports.Parser = Parser;
(function (TokenType) {
    TokenType[TokenType["Whitespace"] = 0] = "Whitespace";
    TokenType[TokenType["Text"] = 1] = "Text";
    TokenType[TokenType["String"] = 2] = "String";
    TokenType[TokenType["Comment"] = 3] = "Comment";
    TokenType[TokenType["Key"] = 4] = "Key";
})(exports.TokenType || (exports.TokenType = {}));
var TokenType = exports.TokenType;
//# sourceMappingURL=parser.js.map