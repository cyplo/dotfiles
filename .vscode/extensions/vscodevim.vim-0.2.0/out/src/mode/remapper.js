"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
const vscode = require('vscode');
const _ = require('lodash');
const mode_1 = require('./mode');
const notation_1 = require('./../notation');
class Remapper {
    constructor(configKey, remappedModes, recursive) {
        this._mostRecentKeys = [];
        this._remappings = [];
        this._recursive = recursive;
        this._remappedModes = remappedModes;
        let remappings = vscode.workspace.getConfiguration('vim')
            .get(configKey, []);
        for (let remapping of remappings) {
            let before = [];
            remapping.before.forEach(item => before.push(notation_1.AngleBracketNotation.Normalize(item)));
            let after = [];
            remapping.after.forEach(item => after.push(notation_1.AngleBracketNotation.Normalize(item)));
            this._remappings.push({
                before: before,
                after: after,
            });
        }
    }
    _longestKeySequence() {
        if (this._remappings.length > 0) {
            return _.maxBy(this._remappings, map => map.before.length).before.length;
        }
        else {
            return 1;
        }
    }
    sendKey(key, modeHandler, vimState) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this._remappedModes.indexOf(vimState.currentMode) === -1) {
                this._reset();
                return false;
            }
            const longestKeySequence = this._longestKeySequence();
            this._mostRecentKeys.push(key);
            this._mostRecentKeys = this._mostRecentKeys.slice(-longestKeySequence);
            for (let sliceLength = 1; sliceLength <= longestKeySequence; sliceLength++) {
                const slice = this._mostRecentKeys.slice(-sliceLength);
                const remapping = _.find(this._remappings, map => map.before.join("") === slice.join(""));
                if (remapping) {
                    // if we remapped e.g. jj to esc, we have to revert the inserted "jj"
                    if (this._remappedModes.indexOf(mode_1.ModeName.Insert) >= 0) {
                        // we subtract 1 because we haven't actually applied the last key.
                        yield vimState.historyTracker.undoAndRemoveChanges(Math.max(0, this._mostRecentKeys.length - 1));
                    }
                    if (!this._recursive) {
                        vimState.isCurrentlyPreformingRemapping = true;
                    }
                    yield modeHandler.handleMultipleKeyEvents(remapping.after);
                    vimState.isCurrentlyPreformingRemapping = false;
                    this._mostRecentKeys = [];
                    return true;
                }
            }
            return false;
        });
    }
    _reset() {
        this._mostRecentKeys = [];
    }
}
class InsertModeRemapper extends Remapper {
    constructor(recursive) {
        super("insertModeKeyBindings" + (recursive ? "" : "NonRecursive"), [mode_1.ModeName.Insert], recursive);
    }
}
exports.InsertModeRemapper = InsertModeRemapper;
class OtherModesRemapper extends Remapper {
    constructor(recursive) {
        super("otherModesKeyBindings" + (recursive ? "" : "NonRecursive"), [mode_1.ModeName.Normal, mode_1.ModeName.Visual, mode_1.ModeName.VisualLine], recursive);
    }
}
exports.OtherModesRemapper = OtherModesRemapper;
//# sourceMappingURL=remapper.js.map