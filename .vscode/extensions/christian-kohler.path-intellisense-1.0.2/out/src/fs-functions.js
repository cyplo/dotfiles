"use strict";
var fs_1 = require('fs');
var path_1 = require('path');
var FileInfo_1 = require('./FileInfo');
function getChildrenOfPath(path) {
    return readdirPromise(path)
        .then(function (files) { return files.filter(notHidden).map(function (f) { return new FileInfo_1.FileInfo(path, f); }); })
        .catch(function () { return []; });
}
exports.getChildrenOfPath = getChildrenOfPath;
function getPath(fileName, text) {
    console.log(fileName);
    console.log(text);
    console.log(path_1.normalize(text));
    console.log(fileName.substring(0, fileName.lastIndexOf(path_1.sep)));
    console.log(text.substring(0, text.lastIndexOf(path_1.sep)));
    console.log(path_1.normalize(text).substring(0, path_1.normalize(text).lastIndexOf(path_1.sep)));
    console.log('====');
    return path_1.resolve(fileName.substring(0, fileName.lastIndexOf(path_1.sep)), path_1.normalize(text).substring(0, path_1.normalize(text).lastIndexOf(path_1.sep)));
    ;
}
exports.getPath = getPath;
function extractExtension(document) {
    if (document.isUntitled) {
        return undefined;
    }
    var fragments = document.fileName.split('.');
    var extension = fragments[fragments.length - 1];
    if (!extension || extension.length > 3) {
        return undefined;
    }
    return extension;
}
exports.extractExtension = extractExtension;
function readdirPromise(path) {
    return new Promise(function (resolve, reject) {
        fs_1.readdir(path, function (error, files) {
            if (error) {
                reject(error);
            }
            else {
                resolve(files);
            }
        });
    });
}
function notHidden(filename) {
    return filename[0] !== '.';
}
//# sourceMappingURL=fs-functions.js.map