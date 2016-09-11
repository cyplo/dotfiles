"use strict";
class AngleBracketNotation {
    static Translate(key) {
        if (!this.IsAngleBracket(key) && key.length > 1) {
            key = `<${key.toLocaleLowerCase()}>`;
        }
        for (const searchKey in this._angleBracketNotationMap) {
            if (this._angleBracketNotationMap.hasOwnProperty(searchKey)) {
                key = key.replace(new RegExp(`(${searchKey})`, 'gi'), this._angleBracketNotationMap[searchKey]);
            }
        }
        return key;
    }
    static IsAngleBracket(key) {
        return key.startsWith('<') && key.endsWith('>');
    }
}
AngleBracketNotation._angleBracketNotationMap = {
    'ctrl+': 'C-',
    'escape': 'Esc',
    'backspace': 'BS',
    'delete': 'Del',
};
exports.AngleBracketNotation = AngleBracketNotation;
//# sourceMappingURL=notation.js.map