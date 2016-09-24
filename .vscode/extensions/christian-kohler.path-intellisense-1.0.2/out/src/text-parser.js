"use strict";
function isInString(text, character) {
    var inSingleQuoationString = (text.substring(0, character).match(/\'/g) || []).length % 2 === 1;
    var inDoubleQuoationString = (text.substring(0, character).match(/\"/g) || []).length % 2 === 1;
    return inSingleQuoationString || inDoubleQuoationString;
}
exports.isInString = isInString;
function isImportOrRequire(text) {
    var isImport = text.substring(0, 6) === 'import';
    var isRequire = text.indexOf('require(') != -1;
    return isImport || isRequire;
}
exports.isImportOrRequire = isImportOrRequire;
function getTextWithinString(text, position) {
    var textToPosition = text.substring(0, position);
    var quoatationPosition = Math.max(textToPosition.lastIndexOf('\"'), textToPosition.lastIndexOf('\''));
    return quoatationPosition != -1 ? textToPosition.substring(quoatationPosition + 1, textToPosition.length) : undefined;
}
exports.getTextWithinString = getTextWithinString;
//# sourceMappingURL=text-parser.js.map