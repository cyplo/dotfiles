"use strict";
(function (ModeName) {
    ModeName[ModeName["Normal"] = 0] = "Normal";
    ModeName[ModeName["Insert"] = 1] = "Insert";
    ModeName[ModeName["Visual"] = 2] = "Visual";
    ModeName[ModeName["VisualBlock"] = 3] = "VisualBlock";
    ModeName[ModeName["VisualLine"] = 4] = "VisualLine";
    ModeName[ModeName["VisualBlockInsertMode"] = 5] = "VisualBlockInsertMode";
    ModeName[ModeName["SearchInProgressMode"] = 6] = "SearchInProgressMode";
    ModeName[ModeName["Replace"] = 7] = "Replace";
})(exports.ModeName || (exports.ModeName = {}));
var ModeName = exports.ModeName;
(function (VSCodeVimCursorType) {
    VSCodeVimCursorType[VSCodeVimCursorType["Native"] = 0] = "Native";
    VSCodeVimCursorType[VSCodeVimCursorType["TextDecoration"] = 1] = "TextDecoration";
})(exports.VSCodeVimCursorType || (exports.VSCodeVimCursorType = {}));
var VSCodeVimCursorType = exports.VSCodeVimCursorType;
class Mode {
    constructor(name) {
        this.isVisualMode = false;
        this._name = name;
        this._isActive = false;
    }
    get name() {
        return this._name;
    }
    get isActive() {
        return this._isActive;
    }
    set isActive(val) {
        this._isActive = val;
    }
}
exports.Mode = Mode;
//# sourceMappingURL=mode.js.map