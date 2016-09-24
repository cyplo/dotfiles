"use strict";
const mode_1 = require('./mode');
const mode_2 = require('./mode');
const position_1 = require('./../motion/position');
class VisualBlockMode extends mode_1.Mode {
    constructor() {
        super(mode_1.ModeName.VisualBlock);
        this.text = "Visual Block Mode";
        this.cursorType = mode_2.VSCodeVimCursorType.TextDecoration;
        this.isVisualMode = true;
    }
    static getTopLeftPosition(start, stop) {
        return new position_1.Position(Math.min(start.line, stop.line), Math.min(start.character, stop.character));
    }
    static getBottomRightPosition(start, stop) {
        return new position_1.Position(Math.max(start.line, stop.line), Math.max(start.character, stop.character));
    }
}
exports.VisualBlockMode = VisualBlockMode;
(function (VisualBlockInsertionType) {
    /**
     * Triggered with I
     */
    VisualBlockInsertionType[VisualBlockInsertionType["Insert"] = 0] = "Insert";
    /**
     * Triggered with A
     */
    VisualBlockInsertionType[VisualBlockInsertionType["Append"] = 1] = "Append";
})(exports.VisualBlockInsertionType || (exports.VisualBlockInsertionType = {}));
var VisualBlockInsertionType = exports.VisualBlockInsertionType;
//# sourceMappingURL=modeVisualBlock.js.map