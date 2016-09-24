"use strict";
class AngleBracketNotation {
    /**
     * Normalizes key to AngleBracketNotation
     * For instance, <ctrl+x>, Ctrl+x, <c-x> normalized to <C-x>
     */
    static Normalize(key) {
        if (!this.isSurroundedByAngleBrackets(key) && key.length > 1) {
            key = `<${key.toLocaleLowerCase()}>`;
        }
        for (const notationMapKey in this._notationMap) {
            if (this._notationMap.hasOwnProperty(notationMapKey)) {
                const regex = new RegExp(this._notationMap[notationMapKey].join('|'), 'gi');
                if (regex.test(key)) {
                    key = key.replace(regex, notationMapKey);
                    break;
                }
            }
        }
        return key;
    }
    static isSurroundedByAngleBrackets(key) {
        return key.startsWith('<') && key.endsWith('>');
    }
}
AngleBracketNotation._notationMap = {
    'C-': ['ctrl\\+', 'c\\-'],
    'Esc': ['escape', 'esc'],
    'BS': ['backspace', 'bs'],
    'Del': ['delete', 'del'],
};
exports.AngleBracketNotation = AngleBracketNotation;
//# sourceMappingURL=notation.js.map