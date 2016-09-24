/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var parser_1 = require('../parser');
var DockerComposeParser = (function (_super) {
    __extends(DockerComposeParser, _super);
    function DockerComposeParser() {
        var parseRegex = /\:+$/g;
        _super.call(this, parseRegex);
    }
    DockerComposeParser.prototype.parseLine = function (textLine) {
        var r = [];
        var lastTokenEndIndex = 0, lastPushedToken = null;
        var emit = function (end, type) {
            if (end <= lastTokenEndIndex) {
                return;
            }
            if (lastPushedToken && lastPushedToken.type === type) {
                // merge with last pushed token
                lastPushedToken.endIndex = end;
                lastTokenEndIndex = end;
                return;
            }
            lastPushedToken = {
                startIndex: lastTokenEndIndex,
                endIndex: end,
                type: type
            };
            r.push(lastPushedToken);
            lastTokenEndIndex = end;
        };
        var inString = false;
        var idx = textLine.firstNonWhitespaceCharacterIndex;
        var line = textLine.text;
        for (var i = idx, len = line.length; i < len; i++) {
            var ch = line.charAt(i);
            if (inString) {
                if (ch === '"' && line.charAt(i - 1) !== '\\') {
                    inString = false;
                    emit(i + 1, parser_1.TokenType.String);
                }
                continue;
            }
            if (ch === '"') {
                emit(i, parser_1.TokenType.Text);
                inString = true;
                continue;
            }
            if (ch === '#') {
                // Comment the rest of the line
                emit(i, parser_1.TokenType.Text);
                emit(line.length, parser_1.TokenType.Comment);
                break;
            }
            if (ch === ':') {
                emit(i + 1, parser_1.TokenType.Key);
            }
            if (ch === ' ' || ch === '\t') {
                emit(i, parser_1.TokenType.Text);
                emit(i + 1, parser_1.TokenType.Whitespace);
            }
        }
        emit(line.length, parser_1.TokenType.Text);
        return r;
    };
    return DockerComposeParser;
}(parser_1.Parser));
exports.DockerComposeParser = DockerComposeParser;
//# sourceMappingURL=dockerComposeParser.js.map