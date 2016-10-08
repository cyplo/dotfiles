/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
"use strict";
var dockerHoverProvider_1 = require('./dockerHoverProvider');
var dockerfileCompletionItemProvider_1 = require('./dockerfile/dockerfileCompletionItemProvider');
var dockerComposeCompletionItemProvider_1 = require('./dockerCompose/dockerComposeCompletionItemProvider');
var dockerfileKeyInfo_1 = require('./dockerfile/dockerfileKeyInfo');
var dockerComposeKeyInfo_1 = require('./dockerCompose/dockerComposeKeyInfo');
var dockerComposeParser_1 = require('./dockerCompose/dockerComposeParser');
var dockerfileParser_1 = require('./dockerfile/dockerfileParser');
var vscode = require('vscode');
function activate(ctx) {
    var DOCKERFILE_MODE_ID = { language: 'dockerfile', scheme: 'file' };
    var dockerHoverProvider = new dockerHoverProvider_1.DockerHoverProvider(new dockerfileParser_1.DockerfileParser(), dockerfileKeyInfo_1.DOCKERFILE_KEY_INFO);
    ctx.subscriptions.push(vscode.languages.registerHoverProvider(DOCKERFILE_MODE_ID, dockerHoverProvider));
    ctx.subscriptions.push(vscode.languages.registerCompletionItemProvider(DOCKERFILE_MODE_ID, new dockerfileCompletionItemProvider_1.DockerfileCompletionItemProvider(), '.'));
    var YAML_MODE_ID = { language: 'yaml', scheme: 'file', pattern: '**/docker-compose*.yml' };
    var yamlHoverProvider = new dockerHoverProvider_1.DockerHoverProvider(new dockerComposeParser_1.DockerComposeParser(), dockerComposeKeyInfo_1.DOCKER_COMPOSE_KEY_INFO);
    ctx.subscriptions.push(vscode.languages.registerHoverProvider(YAML_MODE_ID, yamlHoverProvider));
    ctx.subscriptions.push(vscode.languages.registerCompletionItemProvider(YAML_MODE_ID, new dockerComposeCompletionItemProvider_1.DockerComposeCompletionItemProvider(), '.'));
}
exports.activate = activate;
//# sourceMappingURL=dockerExtension.js.map