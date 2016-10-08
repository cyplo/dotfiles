/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var vscode = require('vscode');
var hub = require('../dockerHubApi');
var parser = require('../parser');
var SuggestSupportHelper = (function () {
    function SuggestSupportHelper() {
    }
    SuggestSupportHelper.prototype.suggestImages = function (word) {
        return hub.searchImagesInRegistryHub(word, true).then(function (results) {
            return results.map(function (image) {
                var stars = '';
                if (image.star_count > 0) {
                    stars = ' ' + image.star_count + ' ' + (image.star_count > 1 ? 'stars' : 'star');
                }
                return {
                    label: image.name,
                    kind: vscode.CompletionItemKind.Value,
                    detail: hub.tagsForImage(image) + stars,
                    insertText: image.name,
                    documentation: image.description,
                };
            });
        });
    };
    SuggestSupportHelper.prototype.searchImageInRegistryHub = function (imageName) {
        return hub.searchImageInRegistryHub(imageName, true).then(function (result) {
            if (result) {
                var r = [];
                var tags = hub.tagsForImage(result);
                // Name, tags and stars.
                var nameString = '';
                if (tags.length > 0) {
                    nameString = '**' + result.name + ' ' + tags + '** ';
                }
                else {
                    nameString = '**' + result.name + '**';
                }
                if (result.star_count) {
                    var plural = (result.star_count > 1);
                    nameString += '**' + String(result.star_count) + (plural ? ' stars' : ' star') + '**';
                }
                r.push(nameString);
                // Description
                r.push(result.description);
                return r;
            }
        });
    };
    SuggestSupportHelper.prototype.getImageNameHover = function (line, _parser, tokens, tokenIndex) {
        // -------------
        // Detect <<image: [["something"]]>>
        // Detect <<image: [[something]]>>
        var originalValue = _parser.tokenValue(line, tokens[tokenIndex]);
        var keyToken = null;
        tokenIndex--;
        while (tokenIndex >= 0) {
            var type = tokens[tokenIndex].type;
            if (type === parser.TokenType.String || type === parser.TokenType.Text) {
                return null;
            }
            if (type === parser.TokenType.Key) {
                keyToken = _parser.tokenValue(line, tokens[tokenIndex]);
                break;
            }
            tokenIndex--;
        }
        if (!keyToken) {
            return null;
        }
        var keyName = _parser.keyNameFromKeyToken(keyToken);
        if (keyName === 'image' || keyName === 'FROM') {
            var imageName = originalValue.replace(/^"/, '').replace(/"$/, '');
            return this.searchImageInRegistryHub(imageName).then(function (results) {
                if (results[0] && results[1]) {
                    return ['**DockerHub:**', results[0], '**DockerRuntime**', results[1]];
                }
                if (results[0]) {
                    return results[0];
                }
                return results[1];
            });
        }
    };
    return SuggestSupportHelper;
}());
exports.SuggestSupportHelper = SuggestSupportHelper;
//# sourceMappingURL=suggestSupportHelper.js.map