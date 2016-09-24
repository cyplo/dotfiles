/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var helper = require('../helpers/suggestSupportHelper');
// IntelliSense
var DockerfileCompletionItemProvider = (function () {
    function DockerfileCompletionItemProvider() {
        this.triggerCharacters = [];
        this.excludeTokens = [];
    }
    DockerfileCompletionItemProvider.prototype.provideCompletionItems = function (document, position, token) {
        var dockerSuggestSupport = new helper.SuggestSupportHelper();
        var textLine = document.lineAt(position.line);
        // Matches strings like: 'FROM imagename'
        var fromTextDocker = textLine.text.match(/^\s*FROM\s*([^"]*)$/);
        if (fromTextDocker) {
            return dockerSuggestSupport.suggestImages(fromTextDocker[1]);
        }
        return Promise.resolve([]);
    };
    return DockerfileCompletionItemProvider;
}());
exports.DockerfileCompletionItemProvider = DockerfileCompletionItemProvider;
//# sourceMappingURL=dockerfileCompletionItemProvider.js.map