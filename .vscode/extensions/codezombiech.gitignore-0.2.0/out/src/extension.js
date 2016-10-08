'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var vscode = require('vscode');
var GitHubApi = require('github');
var fs = require('fs');
var https = require('https');
var CancellationError = (function (_super) {
    __extends(CancellationError, _super);
    function CancellationError() {
        _super.apply(this, arguments);
    }
    return CancellationError;
}(Error));
var CacheItem = (function () {
    function CacheItem(value) {
        this._value = value;
        this.storeDate = new Date();
    }
    Object.defineProperty(CacheItem.prototype, "value", {
        get: function () {
            return this._value;
        },
        enumerable: true,
        configurable: true
    });
    CacheItem.prototype.isExpired = function (expirationInterval) {
        return this.storeDate.getTime() + expirationInterval * 1000 < Date.now();
    };
    return CacheItem;
}());
var GitignoreRepository = (function () {
    function GitignoreRepository(client) {
        this.client = client;
        var config = vscode.workspace.getConfiguration('gitignore');
        this.cacheExpirationInterval = config.get('cacheExpirationInterval', 3600);
    }
    /**
     * Get all .gitignore files
     */
    GitignoreRepository.prototype.getFiles = function () {
        var _this = this;
        return new Promise(function (resolve, reject) {
            // If cached, return cached content
            if (_this.cache && !_this.cache.isExpired(_this.cacheExpirationInterval)) {
                resolve(_this.cache.value);
                return;
            }
            // Download .gitignore files from github
            _this.client.repos.getContent({
                user: 'github',
                repo: 'gitignore',
                path: ''
            }, function (err, response) {
                if (err) {
                    reject(err.message);
                    return;
                }
                var files = response
                    .filter(function (file) {
                    return (file.type === 'file' && file.name.endsWith('.gitignore'));
                })
                    .map(function (file) {
                    return {
                        label: file.name.replace(/\.gitignore/, ''),
                        description: file.name,
                        url: file.download_url
                    };
                });
                // Cache the retrieved gitignore files
                _this.cache = new CacheItem(files);
                resolve(files);
            });
        });
    };
    /**
     * Downloads a .gitignore from the repository to the path passed
     */
    GitignoreRepository.prototype.download = function (gitignoreFile, path) {
        return new Promise(function (resolve, reject) {
            var file = fs.createWriteStream(path);
            var request = https.get(gitignoreFile.url, function (response) {
                response.pipe(file);
                file.on('finish', function () {
                    file.close(function () {
                        resolve(gitignoreFile);
                    });
                });
            }).on('error', function (err) {
                // Delete the file
                fs.unlink(path);
                reject(err.message);
            });
        });
    };
    return GitignoreRepository;
}());
// Create a Github API client
var client = new GitHubApi({
    version: '3.0.0',
    protocol: 'https',
    host: 'api.github.com',
    //debug: true,
    pathPrefix: '',
    timeout: 5000,
    headers: {
        'user-agent': 'vscode-gitignore-extension'
    }
});
// Create gitignore repository
var gitignoreRepository = new GitignoreRepository(client);
function activate(context) {
    console.log('extension "gitignore" is now active!');
    var disposable = vscode.commands.registerCommand('addgitignore', function () {
        // Check if workspace open
        if (!vscode.workspace.rootPath) {
            vscode.window.showErrorMessage('No workspace directory open');
            return;
        }
        Promise.resolve(vscode.window.showQuickPick(gitignoreRepository.getFiles()))
            .then(function (file) {
            if (!file) {
                // Cancel
                throw new CancellationError();
            }
            var path = vscode.workspace.rootPath + '/.gitignore';
            return new Promise(function (resolve, reject) {
                // Check if file exists
                fs.stat(path, function (err, stats) {
                    if (err) {
                        // File does not exists -> we are fine to create it
                        resolve({ path: path, file: file });
                    }
                    else {
                        reject('.gitignore already exists');
                    }
                });
            });
        })
            .then(function (s) {
            // Store the file on file system
            return gitignoreRepository.download(s.file, s.path);
        })
            .then(function (file) {
            vscode.window.showInformationMessage("Added " + file.description + " to your project root");
        })
            .catch(function (reason) {
            if (reason instanceof CancellationError) {
                return;
            }
            vscode.window.showErrorMessage(reason);
        });
    });
    context.subscriptions.push(disposable);
}
exports.activate = activate;
// this method is called when your extension is deactivated
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map