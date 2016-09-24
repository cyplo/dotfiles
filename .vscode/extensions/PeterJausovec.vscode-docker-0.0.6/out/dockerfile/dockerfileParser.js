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
var DockerfileParser = (function (_super) {
    __extends(DockerfileParser, _super);
    function DockerfileParser() {
        var parseRegex = /\ +$/g;
        _super.call(this, parseRegex);
    }
    DockerfileParser.prototype.parseLine = function (textLine) {
        if (textLine.isEmptyOrWhitespace) {
            return null;
        }
        var startIndex = textLine.firstNonWhitespaceCharacterIndex;
        // Check for comment 
        if (textLine.text.charAt(startIndex) === '#') {
            return null;
        }
        var tokens = [];
        var previousTokenIndex = 0;
        var keyFound = false;
        for (var j = startIndex, len = textLine.text.length; j < len; j++) {
            var ch = textLine.text.charAt(j);
            if (ch === ' ' || ch === '\t') {
                previousTokenIndex = j;
                tokens.push({
                    startIndex: 0,
                    endIndex: j,
                    type: parser_1.TokenType.Key
                });
                break;
            }
        }
        tokens.push({
            startIndex: previousTokenIndex,
            endIndex: textLine.text.length,
            type: parser_1.TokenType.String
        });
        return tokens;
    };
    return DockerfileParser;
}(parser_1.Parser));
exports.DockerfileParser = DockerfileParser;
//# sourceMappingURL=dockerfileParser.js.map