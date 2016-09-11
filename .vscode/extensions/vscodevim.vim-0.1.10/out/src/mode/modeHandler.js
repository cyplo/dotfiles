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
const extension_1 = require('./../../extension');
const mode_1 = require('./mode');
const remapper_1 = require('./remapper');
const modeNormal_1 = require('./modeNormal');
const modeInsert_1 = require('./modeInsert');
const modeVisualBlock_1 = require('./modeVisualBlock');
const modeInsertVisualBlock_1 = require('./modeInsertVisualBlock');
const modeVisual_1 = require('./modeVisual');
const modeReplace_1 = require('./modeReplace');
const modeSearchInProgress_1 = require('./modeSearchInProgress');
const textEditor_1 = require('./../textEditor');
const modeVisualLine_1 = require('./modeVisualLine');
const historyTracker_1 = require('./../history/historyTracker');
const actions_1 = require('./../actions/actions');
const position_1 = require('./../motion/position');
const register_1 = require('./../register/register');
const main_1 = require('../../src/cmd_line/main');
const configuration_1 = require('../../src/configuration/configuration');
const matcher_1 = require('./../matching/matcher');
const globals_1 = require('../../src/globals');
(function (VimSpecialCommands) {
    VimSpecialCommands[VimSpecialCommands["Nothing"] = 0] = "Nothing";
    VimSpecialCommands[VimSpecialCommands["ShowCommandLine"] = 1] = "ShowCommandLine";
    VimSpecialCommands[VimSpecialCommands["Dot"] = 2] = "Dot";
})(exports.VimSpecialCommands || (exports.VimSpecialCommands = {}));
var VimSpecialCommands = exports.VimSpecialCommands;
/**
 * The VimState class holds permanent state that carries over from action
 * to action.
 *
 * Actions defined in actions.ts are only allowed to mutate a VimState in order to
 * indicate what they want to do.
 */
class VimState {
    constructor() {
        /**
         * The column the cursor wants to be at, or Number.POSITIVE_INFINITY if it should always
         * be the rightmost column.
         *
         * Example: If you go to the end of a 20 character column, this value
         * will be 20, even if you press j and the next column is only 5 characters.
         * This is because if the third column is 25 characters, the cursor will go
         * back to the 20th column.
         */
        this.desiredColumn = 0;
        /**
         * The keystroke sequence that made up our last complete action (that can be
         * repeated with '.').
         */
        this.previousFullAction = undefined;
        this.alteredHistory = false;
        this.isRunningDotCommand = false;
        this.focusChanged = false;
        /**
         * Used to prevent non-recursive remappings from looping.
         */
        this.isCurrentlyPreformingRemapping = false;
        /**
         * The current full action we are building up.
         */
        this.currentFullAction = [];
        /**
         * The position the cursor will be when this action finishes.
         */
        // public cursorPosition = new Position(0, 0);
        this._cursorPosition = new position_1.Position(0, 0);
        /**
         * The effective starting position of the movement, used along with cursorPosition to determine
         * the range over which to run an Operator. May rarely be different than where the cursor
         * actually starts e.g. if you use the "aw" text motion in the middle of a word.
         */
        this.cursorStartPosition = new position_1.Position(0, 0);
        this.cursorPositionJustBeforeAnythingHappened = new position_1.Position(0, 0);
        this.searchState = undefined;
        this.searchStatePrevious = undefined;
        this.replaceState = undefined;
        /**
         * The mode Vim will be in once this action finishes.
         */
        this.currentMode = mode_1.ModeName.Normal;
        this.currentRegisterMode = register_1.RegisterMode.FigureItOutFromCurrentMode;
        /**
         * This is for oddball commands that don't manipulate text in any way.
         */
        this.commandAction = VimSpecialCommands.Nothing;
        this.commandInitialText = "";
        this.recordedState = new RecordedState();
    }
    get cursorPosition() { return this._cursorPosition; }
    set cursorPosition(v) {
        this._cursorPosition = v;
    }
    getModeObject(modeHandler) {
        return modeHandler.modeList.find(mode => mode.isActive);
    }
    effectiveRegisterMode() {
        if (this.currentRegisterMode === register_1.RegisterMode.FigureItOutFromCurrentMode) {
            if (this.currentMode === mode_1.ModeName.VisualLine) {
                return register_1.RegisterMode.LineWise;
            }
            else if (this.currentMode === mode_1.ModeName.VisualBlock || this.currentMode === mode_1.ModeName.VisualBlockInsertMode) {
                return register_1.RegisterMode.BlockWise;
            }
            else {
                return register_1.RegisterMode.CharacterWise;
            }
        }
        else {
            return this.currentRegisterMode;
        }
    }
    /**
     * The top left of a selected block of text. Useful for Visual Block mode.
     */
    get topLeft() {
        return modeVisualBlock_1.VisualBlockMode.getTopLeftPosition(this.cursorStartPosition, this.cursorPosition);
    }
    /**
     * The bottom right of a selected block of text. Useful for Visual Block mode.
     */
    get bottomRight() {
        return modeVisualBlock_1.VisualBlockMode.getBottomRightPosition(this.cursorStartPosition, this.cursorPosition);
    }
}
VimState.lastRepeatableMovement = undefined;
exports.VimState = VimState;
(function (SearchDirection) {
    SearchDirection[SearchDirection["Forward"] = 1] = "Forward";
    SearchDirection[SearchDirection["Backward"] = -1] = "Backward";
})(exports.SearchDirection || (exports.SearchDirection = {}));
var SearchDirection = exports.SearchDirection;
class SearchState {
    constructor(direction, startPosition, searchString = "", { isRegex = false } = {}) {
        /**
         * Every range in the document that matches the search string.
         */
        this._matchRanges = [];
        this._searchDirection = SearchDirection.Forward;
        this._searchString = "";
        this._searchDirection = direction;
        this._searchCursorStartPosition = startPosition;
        this.searchString = searchString;
        this.isRegex = isRegex;
    }
    get matchRanges() {
        return this._matchRanges;
    }
    get searchCursorStartPosition() {
        return this._searchCursorStartPosition;
    }
    get searchString() {
        return this._searchString;
    }
    set searchString(search) {
        if (this._searchString !== search) {
            this._searchString = search;
            this._recalculateSearchRanges({ forceRecalc: true });
        }
    }
    _recalculateSearchRanges({ forceRecalc } = {}) {
        const search = this.searchString;
        if (search === "") {
            return;
        }
        if (this._matchesDocVersion !== textEditor_1.TextEditor.getDocumentVersion() || forceRecalc) {
            // Calculate and store all matching ranges
            this._matchesDocVersion = textEditor_1.TextEditor.getDocumentVersion();
            this._matchRanges = [];
            /* Decide whether the search is case sensitive.
             * If ignorecase is false, the search is case sensitive.
             * If ignorecase is true, the search should be case insensitive.
             * If both ignorecase and smartcase are true, the search is case sensitive only when the search string contains UpperCase character.
             */
            let ignorecase = configuration_1.Configuration.getInstance().ignorecase;
            if (ignorecase && configuration_1.Configuration.getInstance().smartcase && /[A-Z]/.test(search)) {
                ignorecase = false;
            }
            let searchRE = search;
            if (!this.isRegex) {
                searchRE = search.replace(SearchState.specialCharactersRegex, "\\$&");
            }
            const regexFlags = ignorecase ? 'gi' : 'g';
            let regex;
            try {
                regex = new RegExp(searchRE, regexFlags);
            }
            catch (err) {
                // Couldn't compile the regexp, try again with special characters escaped
                searchRE = search.replace(SearchState.specialCharactersRegex, "\\$&");
                regex = new RegExp(searchRE, regexFlags);
            }
            outer: for (let lineIdx = 0; lineIdx < textEditor_1.TextEditor.getLineCount(); lineIdx++) {
                const line = textEditor_1.TextEditor.getLineAt(new position_1.Position(lineIdx, 0)).text;
                let result = regex.exec(line);
                while (result) {
                    if (this._matchRanges.length >= SearchState.MAX_SEARCH_RANGES) {
                        break outer;
                    }
                    this.matchRanges.push(new vscode.Range(new position_1.Position(lineIdx, result.index), new position_1.Position(lineIdx, result.index + result[0].length)));
                    if (result.index === regex.lastIndex) {
                        regex.lastIndex++;
                    }
                    result = regex.exec(line);
                }
            }
        }
    }
    /**
     * The position of the next search, or undefined if there is no match.
     *
     * Pass in -1 as direction to reverse the direction we search.
     */
    getNextSearchMatchPosition(startPosition, direction = 1) {
        this._recalculateSearchRanges();
        if (this._matchRanges.length === 0) {
            // TODO(bell)
            return { pos: startPosition, match: false };
        }
        const effectiveDirection = direction * this._searchDirection;
        if (effectiveDirection === SearchDirection.Forward) {
            for (let matchRange of this._matchRanges) {
                if (matchRange.start.compareTo(startPosition) > 0) {
                    return { pos: position_1.Position.FromVSCodePosition(matchRange.start), match: true };
                }
            }
            // Wrap around
            // TODO(bell)
            return { pos: position_1.Position.FromVSCodePosition(this._matchRanges[0].start), match: true };
        }
        else {
            for (let matchRange of this._matchRanges.slice(0).reverse()) {
                if (matchRange.start.compareTo(startPosition) < 0) {
                    return { pos: position_1.Position.FromVSCodePosition(matchRange.start), match: true };
                }
            }
            // TODO(bell)
            return {
                pos: position_1.Position.FromVSCodePosition(this._matchRanges[this._matchRanges.length - 1].start),
                match: true
            };
        }
    }
}
SearchState.MAX_SEARCH_RANGES = 1000;
SearchState.specialCharactersRegex = /[\-\[\]{}()*+?.,\\\^$|#\s]/g;
exports.SearchState = SearchState;
class ReplaceState {
    constructor(startPosition) {
        this.originalChars = [];
        this._replaceCursorStartPosition = startPosition;
        let text = textEditor_1.TextEditor.getLineAt(startPosition).text.substring(startPosition.character);
        for (let [key, value] of text.split("").entries()) {
            this.originalChars[key + startPosition.character] = value;
        }
    }
    get replaceCursorStartPosition() {
        return this._replaceCursorStartPosition;
    }
}
exports.ReplaceState = ReplaceState;
/**
 * The RecordedState class holds the current action that the user is
 * doing. Example: Imagine that the user types:
 *
 * 5"qdw
 *
 * Then the relevent state would be
 *   * count of 5
 *   * copy into q register
 *   * delete operator
 *   * word movement
 *
 *
 * Or imagine the user types:
 *
 * vw$}}d
 *
 * Then the state would be
 *   * Visual mode action
 *   * (a list of all the motions you ran)
 *   * delete operator
 */
class RecordedState {
    constructor() {
        /**
         * Keeps track of keys pressed for the next action. Comes in handy when parsing
         * multiple length movements, e.g. gg.
         */
        this.actionKeys = [];
        this.actionsRun = [];
        this.hasRunOperator = false;
        this.visualBlockInsertionType = modeVisualBlock_1.VisualBlockInsertionType.Insert;
        /**
         * The number of times the user wants to repeat this action.
         */
        this.count = 0;
        const useClipboard = configuration_1.Configuration.getInstance().useSystemClipboard;
        this.registerName = useClipboard ? '*' : '"';
    }
    /**
     * The operator (e.g. d, y, >) the user wants to run, if there is one.
     */
    get operator() {
        const list = _.filter(this.actionsRun, a => a instanceof actions_1.BaseOperator);
        if (list.length > 1) {
            throw "Too many operators!";
        }
        return list[0];
    }
    get command() {
        const list = _.filter(this.actionsRun, a => a instanceof actions_1.BaseCommand);
        // TODO - disregard <Esc>, then assert this is of length 1.
        return list[0];
    }
    get hasRunAMovement() {
        return _.filter(this.actionsRun, a => a.isMotion).length > 0;
    }
    clone() {
        const res = new RecordedState();
        // TODO: Actual clone.
        res.actionKeys = this.actionKeys.slice(0);
        res.actionsRun = this.actionsRun.slice(0);
        res.hasRunOperator = this.hasRunOperator;
        return res;
    }
    operatorReadyToExecute(mode) {
        // Visual modes do not require a motion -- they ARE the motion.
        return this.operator &&
            !this.hasRunOperator &&
            mode !== mode_1.ModeName.SearchInProgressMode &&
            (this.hasRunAMovement || (mode === mode_1.ModeName.Visual ||
                mode === mode_1.ModeName.VisualLine));
    }
    get isInInitialState() {
        return this.operator === undefined &&
            this.actionsRun.length === 0 &&
            this.count === 1;
    }
    toString() {
        let res = "";
        for (const action of this.actionsRun) {
            res += action.toString();
        }
        return res;
    }
}
exports.RecordedState = RecordedState;
class ModeHandler {
    /**
     * isTesting speeds up tests drastically by turning off our checks for
     * mouse events.
     */
    constructor(filename = "") {
        this._caretDecoration = vscode.window.createTextEditorDecorationType({
            dark: {
                // used for dark colored themes
                backgroundColor: 'rgba(224, 224, 224, 0.4)',
                borderColor: 'rgba(224, 224, 224, 0.4)'
            },
            light: {
                // used for light colored themes
                backgroundColor: 'rgba(32, 32, 32, 0.4)',
                borderColor: 'rgba(32, 32, 32, 0.4)'
            },
            borderStyle: 'solid',
            borderWidth: '1px'
        });
        ModeHandler.IsTesting = globals_1.Globals.isTesting;
        this.fileName = filename;
        this._vimState = new VimState();
        this._insertModeRemapper = new remapper_1.InsertModeRemapper(true);
        this._otherModesRemapper = new remapper_1.OtherModesRemapper(true);
        this._insertModeNonRecursive = new remapper_1.InsertModeRemapper(false);
        this._otherModesNonRecursive = new remapper_1.OtherModesRemapper(false);
        this._modes = [
            new modeNormal_1.NormalMode(this),
            new modeInsert_1.InsertMode(),
            new modeVisual_1.VisualMode(),
            new modeVisualBlock_1.VisualBlockMode(),
            new modeInsertVisualBlock_1.InsertVisualBlockMode(),
            new modeVisualLine_1.VisualLineMode(),
            new modeSearchInProgress_1.SearchInProgressMode(),
            new modeReplace_1.ReplaceMode(),
        ];
        this.vimState.historyTracker = new historyTracker_1.HistoryTracker();
        this._vimState.currentMode = mode_1.ModeName.Normal;
        this.setCurrentModeByName(this._vimState);
        // Sometimes, Visual Studio Code will start the cursor in a position which
        // is not (0, 0) - e.g., if you previously edited the file and left the cursor
        // somewhere else when you closed it. This will set our cursor's position to the position
        // that VSC set it to.
        if (vscode.window.activeTextEditor) {
            this._vimState.cursorStartPosition = position_1.Position.FromVSCodePosition(vscode.window.activeTextEditor.selection.start);
            this._vimState.cursorPosition = position_1.Position.FromVSCodePosition(vscode.window.activeTextEditor.selection.start);
        }
        // Handle scenarios where mouse used to change current position.
        vscode.window.onDidChangeTextEditorSelection((e) => __awaiter(this, void 0, void 0, function* () {
            let selection = e.selections[0];
            if (ModeHandler.IsTesting) {
                return;
            }
            if (e.textEditor.document.fileName !== this.fileName) {
                return;
            }
            if (this.currentModeName === mode_1.ModeName.VisualBlock) {
                // Not worth it until we get a better API for this stuff.
                return;
            }
            if (this._vimState.focusChanged) {
                this._vimState.focusChanged = false;
                return;
            }
            // See comment about whatILastSetTheSelectionTo.
            if (this._vimState.whatILastSetTheSelectionTo.isEqual(selection)) {
                return;
            }
            if (this._vimState.currentMode === mode_1.ModeName.SearchInProgressMode ||
                this._vimState.currentMode === mode_1.ModeName.VisualBlockInsertMode) {
                return;
            }
            if (selection) {
                var newPosition = new position_1.Position(selection.active.line, selection.active.character);
                if (newPosition.character >= newPosition.getLineEnd().character) {
                    newPosition = new position_1.Position(newPosition.line, Math.max(newPosition.getLineEnd().character, 0));
                }
                this._vimState.cursorPosition = newPosition;
                this._vimState.cursorStartPosition = newPosition;
                this._vimState.desiredColumn = newPosition.character;
                // start visual mode?
                if (!selection.anchor.isEqual(selection.active)) {
                    var selectionStart = new position_1.Position(selection.anchor.line, selection.anchor.character);
                    if (selectionStart.character > selectionStart.getLineEnd().character) {
                        selectionStart = new position_1.Position(selectionStart.line, selectionStart.getLineEnd().character);
                    }
                    this._vimState.cursorStartPosition = selectionStart;
                    if (selectionStart.compareTo(newPosition) > 0) {
                        this._vimState.cursorStartPosition = this._vimState.cursorStartPosition.getLeft();
                    }
                    if (!this._vimState.getModeObject(this).isVisualMode) {
                        this._vimState.currentMode = mode_1.ModeName.Visual;
                        this.setCurrentModeByName(this._vimState);
                        // double click mouse selection causes an extra character to be selected so take one less character
                        this._vimState.cursorPosition = this._vimState.cursorPosition.getLeft();
                    }
                }
                else {
                    if (this._vimState.currentMode !== mode_1.ModeName.Insert) {
                        this._vimState.currentMode = mode_1.ModeName.Normal;
                        this.setCurrentModeByName(this._vimState);
                    }
                }
                yield this.updateView(this._vimState, false);
            }
        }));
    }
    get vimState() {
        return this._vimState;
    }
    get currentModeName() {
        return this.currentMode.name;
    }
    get modeList() {
        return this._modes;
    }
    /**
     * The active mode.
     */
    get currentMode() {
        return this._modes.find(mode => mode.isActive);
    }
    setCurrentModeByName(vimState) {
        let activeMode;
        this._vimState.currentMode = vimState.currentMode;
        for (let mode of this._modes) {
            if (mode.name === vimState.currentMode) {
                activeMode = mode;
            }
            mode.isActive = (mode.name === vimState.currentMode);
        }
    }
    handleKeyEvent(key) {
        return __awaiter(this, void 0, void 0, function* () {
            this._vimState.cursorPositionJustBeforeAnythingHappened = this._vimState.cursorPosition;
            try {
                let handled = false;
                if (!this._vimState.isCurrentlyPreformingRemapping) {
                    // Non-recursive remapping do not allow for further mappings
                    handled = handled || (yield this._insertModeRemapper.sendKey(key, this, this.vimState));
                    handled = handled || (yield this._otherModesRemapper.sendKey(key, this, this.vimState));
                    handled = handled || (yield this._insertModeNonRecursive.sendKey(key, this, this.vimState));
                    handled = handled || (yield this._otherModesNonRecursive.sendKey(key, this, this.vimState));
                }
                if (!handled) {
                    this._vimState = yield this.handleKeyEventHelper(key, this._vimState);
                }
            }
            catch (e) {
                console.log('error.stack');
                console.log(e);
                console.log(e.stack);
            }
            if (this._vimState.focusChanged) {
                yield extension_1.getAndUpdateModeHandler();
            }
            return true;
        });
    }
    handleKeyEventHelper(key, vimState) {
        return __awaiter(this, void 0, void 0, function* () {
            // Catch any text change not triggered by us (example: tab completion).
            vimState.historyTracker.addChange(this._vimState.cursorPositionJustBeforeAnythingHappened);
            let recordedState = vimState.recordedState;
            recordedState.actionKeys.push(key);
            vimState.currentFullAction.push(key);
            let result = actions_1.Actions.getRelevantAction(recordedState.actionKeys, vimState);
            if (result === actions_1.KeypressState.NoPossibleMatch) {
                vimState.recordedState = new RecordedState();
                return vimState;
            }
            else if (result === actions_1.KeypressState.WaitingOnKeys) {
                return vimState;
            }
            let action = result;
            recordedState.actionsRun.push(action);
            vimState = yield this.runAction(vimState, recordedState, action);
            // Updated desired column
            const movement = action instanceof actions_1.BaseMovement ? action : undefined;
            if ((movement && !movement.doesntChangeDesiredColumn) ||
                (recordedState.command &&
                    vimState.currentMode !== mode_1.ModeName.VisualBlock &&
                    vimState.currentMode !== mode_1.ModeName.VisualBlockInsertMode)) {
                // We check !operator here because e.g. d$ should NOT set the desired column to EOL.
                if (movement && movement.setsDesiredColumnToEOL && !recordedState.operator) {
                    vimState.desiredColumn = Number.POSITIVE_INFINITY;
                }
                else {
                    vimState.desiredColumn = vimState.cursorPosition.character;
                }
            }
            // Update view
            yield this.updateView(vimState);
            return vimState;
        });
    }
    runAction(vimState, recordedState, action) {
        return __awaiter(this, void 0, void 0, function* () {
            let ranRepeatableAction = false;
            let ranAction = false;
            // If arrow keys or mouse were in insert mode, create an undo point.
            // This needs to happen before any changes are made
            let prevPos = vimState.historyTracker.getLastHistoryEndPosition();
            if (prevPos !== undefined && !vimState.isRunningDotCommand) {
                if (vimState.cursorPositionJustBeforeAnythingHappened.line !== prevPos.line ||
                    vimState.cursorPositionJustBeforeAnythingHappened.character !== prevPos.character) {
                    vimState.previousFullAction = recordedState;
                    vimState.historyTracker.finishCurrentStep();
                }
            }
            if (action instanceof actions_1.BaseMovement) {
                ({ vimState, recordedState } = yield this.executeMovement(vimState, action));
                ranAction = true;
            }
            if (action instanceof actions_1.BaseCommand) {
                vimState = yield action.execCount(vimState.cursorPosition, vimState);
                if (vimState.commandAction !== VimSpecialCommands.Nothing) {
                    yield this.executeCommand(vimState);
                }
                if (action.isCompleteAction) {
                    ranAction = true;
                }
                if (action.canBeRepeatedWithDot) {
                    ranRepeatableAction = true;
                }
            }
            // Update mode (note the ordering allows you to go into search mode,
            // then return and have the motion immediately applied to an operator).
            if (vimState.currentMode !== this.currentModeName) {
                this.setCurrentModeByName(vimState);
                if (vimState.currentMode === mode_1.ModeName.Normal) {
                    ranRepeatableAction = true;
                }
            }
            if (recordedState.operatorReadyToExecute(vimState.currentMode)) {
                vimState = yield this.executeOperator(vimState);
                vimState.recordedState.hasRunOperator = true;
                ranRepeatableAction = vimState.recordedState.operator.canBeRepeatedWithDot;
                ranAction = true;
            }
            // And then we have to do it again because an operator could
            // have changed it as well. (TODO: do you even decomposition bro)
            if (vimState.currentMode !== this.currentModeName) {
                this.setCurrentModeByName(vimState);
                if (vimState.currentMode === mode_1.ModeName.Normal) {
                    ranRepeatableAction = true;
                }
            }
            ranRepeatableAction = (ranRepeatableAction && vimState.currentMode === mode_1.ModeName.Normal) || this.createUndoPointForBrackets(vimState);
            ranAction = ranAction && vimState.currentMode === mode_1.ModeName.Normal;
            // Record down previous action and flush temporary state
            if (ranRepeatableAction) {
                vimState.previousFullAction = vimState.recordedState;
            }
            if (ranAction) {
                vimState.recordedState = new RecordedState();
            }
            // track undo history
            if (!this.vimState.focusChanged) {
                // important to ensure that focus didn't change, otherwise
                // we'll grab the text of the incorrect active window and assume the
                // whole document changed!
                if (this._vimState.alteredHistory) {
                    this._vimState.alteredHistory = false;
                    vimState.historyTracker.ignoreChange();
                }
                else {
                    vimState.historyTracker.addChange(this._vimState.cursorPositionJustBeforeAnythingHappened);
                }
            }
            if (ranRepeatableAction) {
                vimState.historyTracker.finishCurrentStep();
            }
            //  console.log(vimState.historyTracker.toString());
            recordedState.actionKeys = [];
            vimState.currentRegisterMode = register_1.RegisterMode.FigureItOutFromCurrentMode;
            if (this.currentModeName === mode_1.ModeName.Normal) {
                vimState.cursorStartPosition = vimState.cursorPosition;
            }
            // Ensure cursor is within bounds
            if (vimState.cursorPosition.line >= textEditor_1.TextEditor.getLineCount()) {
                vimState.cursorPosition = vimState.cursorPosition.getDocumentEnd();
            }
            const currentLineLength = textEditor_1.TextEditor.getLineAt(vimState.cursorPosition).text.length;
            if (vimState.currentMode === mode_1.ModeName.Normal &&
                vimState.cursorPosition.character >= currentLineLength &&
                currentLineLength > 0) {
                vimState.cursorPosition = new position_1.Position(vimState.cursorPosition.line, currentLineLength - 1);
            }
            // Update the current history step to have the latest cursor position incase it is needed
            vimState.historyTracker.setLastHistoryEndPosition(vimState.cursorPosition);
            return vimState;
        });
    }
    executeMovement(vimState, movement) {
        return __awaiter(this, void 0, void 0, function* () {
            let recordedState = vimState.recordedState;
            const result = yield movement.execActionWithCount(vimState.cursorPosition, vimState, recordedState.count);
            if (result instanceof position_1.Position) {
                vimState.cursorPosition = result;
            }
            else if (actions_1.isIMovement(result)) {
                if (result.failed) {
                    vimState.recordedState = new RecordedState();
                }
                vimState.cursorPosition = result.stop;
                vimState.cursorStartPosition = result.start;
                if (result.registerMode) {
                    vimState.currentRegisterMode = result.registerMode;
                }
            }
            if (movement.canBeRepeatedWithSemicolon(vimState, result)) {
                VimState.lastRepeatableMovement = movement;
            }
            vimState.recordedState.count = 0;
            let stop = vimState.cursorPosition;
            // Keep the cursor within bounds
            if (vimState.currentMode === mode_1.ModeName.Normal && !recordedState.operator) {
                if (stop.character >= position_1.Position.getLineLength(stop.line)) {
                    vimState.cursorPosition = stop.getLineEnd().getLeft();
                }
            }
            else {
                // Vim does this weird thing where it allows you to select and delete
                // the newline character, which it places 1 past the last character
                // in the line. This is why we use > instead of >=.
                if (stop.character > position_1.Position.getLineLength(stop.line)) {
                    vimState.cursorPosition = stop.getLineEnd();
                }
            }
            return { vimState, recordedState };
        });
    }
    executeOperator(vimState) {
        return __awaiter(this, void 0, void 0, function* () {
            let start = vimState.cursorStartPosition;
            let stop = vimState.cursorPosition;
            let recordedState = vimState.recordedState;
            if (!recordedState.operator) {
                throw new Error("what in god's name");
            }
            if (start.compareTo(stop) > 0) {
                [start, stop] = [stop, start];
            }
            if (!this._vimState.getModeObject(this).isVisualMode &&
                vimState.currentRegisterMode !== register_1.RegisterMode.LineWise) {
                if (position_1.Position.EarlierOf(start, stop) === start) {
                    stop = stop.getLeft();
                }
                else {
                    stop = stop.getRight();
                }
            }
            if (this.currentModeName === mode_1.ModeName.VisualLine) {
                start = start.getLineBegin();
                stop = stop.getLineEnd();
                vimState.currentRegisterMode = register_1.RegisterMode.LineWise;
            }
            return yield recordedState.operator.run(vimState, start, stop);
        });
    }
    executeCommand(vimState) {
        return __awaiter(this, void 0, void 0, function* () {
            const command = vimState.commandAction;
            vimState.commandAction = VimSpecialCommands.Nothing;
            switch (command) {
                case VimSpecialCommands.ShowCommandLine:
                    yield main_1.showCmdLine(vimState.commandInitialText, this);
                    break;
                case VimSpecialCommands.Dot:
                    if (!vimState.previousFullAction) {
                        return vimState; // TODO(bell)
                    }
                    const clonedAction = vimState.previousFullAction.clone();
                    yield this.rerunRecordedState(vimState, vimState.previousFullAction);
                    vimState.previousFullAction = clonedAction;
                    break;
            }
            return vimState;
        });
    }
    rerunRecordedState(vimState, recordedState) {
        return __awaiter(this, void 0, void 0, function* () {
            const actions = recordedState.actionsRun.slice(0);
            recordedState = new RecordedState();
            vimState.recordedState = recordedState;
            vimState.isRunningDotCommand = true;
            let i = 0;
            for (let action of actions) {
                recordedState.actionsRun = actions.slice(0, ++i);
                vimState = yield this.runAction(vimState, recordedState, action);
            }
            vimState.isRunningDotCommand = false;
            recordedState.actionsRun = actions;
            return vimState;
        });
    }
    updateView(vimState, drawSelection = true) {
        return __awaiter(this, void 0, void 0, function* () {
            // Update cursor position
            let start = vimState.cursorStartPosition;
            let stop = vimState.cursorPosition;
            if (vimState.currentMode === mode_1.ModeName.Visual) {
                /**
                 * Always select the letter that we started visual mode on, no matter
                 * if we are in front or behind it. Imagine that we started visual mode
                 * with some text like this:
                 *
                 *   abc|def
                 *
                 * (The | represents the cursor.) If we now press w, we'll select def,
                 * but if we hit b we expect to select abcd, so we need to getRight() on the
                 * start of the selection when it precedes where we started visual mode.
                 */
                if (start.compareTo(stop) > 0) {
                    start = start.getRight();
                }
            }
            // Draw selection (or cursor)
            if (drawSelection) {
                let selections;
                if (vimState.currentMode === mode_1.ModeName.Visual) {
                    selections = [new vscode.Selection(start, stop)];
                }
                else if (vimState.currentMode === mode_1.ModeName.VisualLine) {
                    selections = [new vscode.Selection(position_1.Position.EarlierOf(start, stop).getLineBegin(), position_1.Position.LaterOf(start, stop).getLineEnd())];
                }
                else if (vimState.currentMode === mode_1.ModeName.VisualBlock) {
                    selections = [];
                    for (const { start: lineStart, end } of position_1.Position.IterateLine(vimState)) {
                        selections.push(new vscode.Selection(lineStart, end));
                    }
                }
                else {
                    selections = [new vscode.Selection(stop, stop)];
                }
                this._vimState.whatILastSetTheSelectionTo = selections[0];
                vscode.window.activeTextEditor.selections = selections;
            }
            // Scroll to position of cursor
            vscode.window.activeTextEditor.revealRange(new vscode.Range(vimState.cursorPosition, vimState.cursorPosition));
            let rangesToDraw = [];
            // Draw block cursor.
            if (configuration_1.Configuration.getInstance().useSolidBlockCursor) {
                if (this.currentMode.name !== mode_1.ModeName.Insert) {
                    rangesToDraw.push(new vscode.Range(vimState.cursorPosition, vimState.cursorPosition.getRight()));
                }
            }
            else {
                // Use native block cursor if possible.
                const options = vscode.window.activeTextEditor.options;
                options.cursorStyle = this.currentMode.cursorType === mode_1.VSCodeVimCursorType.Native &&
                    this.currentMode.name !== mode_1.ModeName.VisualBlockInsertMode &&
                    this.currentMode.name !== mode_1.ModeName.Insert ?
                    vscode.TextEditorCursorStyle.Block : vscode.TextEditorCursorStyle.Line;
                vscode.window.activeTextEditor.options = options;
            }
            if (this.currentMode.cursorType === mode_1.VSCodeVimCursorType.TextDecoration &&
                this.currentMode.name !== mode_1.ModeName.Insert) {
                // Fake block cursor with text decoration. Unfortunately we can't have a cursor
                // in the middle of a selection natively, which is what we need for Visual Mode.
                rangesToDraw.push(new vscode.Range(stop, stop.getRight()));
            }
            // Draw marks
            // I should re-enable this with a config setting at some point
            /*
        
            for (const mark of this.vimState.historyTracker.getMarks()) {
              rangesToDraw.push(new vscode.Range(mark.position, mark.position.getRight()));
            }
        
            */
            // Draw search highlight
            if (this.currentMode.name === mode_1.ModeName.SearchInProgressMode ||
                (configuration_1.Configuration.getInstance().hlsearch && vimState.searchState)) {
                const searchState = vimState.searchState;
                rangesToDraw.push.apply(rangesToDraw, searchState.matchRanges);
                const { pos, match } = searchState.getNextSearchMatchPosition(vimState.cursorPosition);
                if (match) {
                    rangesToDraw.push(new vscode.Range(pos, pos.getRight(searchState.searchString.length)));
                }
            }
            vscode.window.activeTextEditor.setDecorations(this._caretDecoration, rangesToDraw);
            if (this.currentMode.name === mode_1.ModeName.SearchInProgressMode) {
                this.setupStatusBarItem(`Searching for: ${this.vimState.searchState.searchString}`);
            }
            else {
                this.setupStatusBarItem(`-- ${this.currentMode.text.toUpperCase()} --`);
            }
            vscode.commands.executeCommand('setContext', 'vim.mode', this.currentMode.text);
            vscode.commands.executeCommand('setContext', 'vim.useCtrlKeys', configuration_1.Configuration.getInstance().useCtrlKeys);
        });
    }
    handleMultipleKeyEvents(keys) {
        return __awaiter(this, void 0, void 0, function* () {
            for (const key of keys) {
                yield this.handleKeyEvent(key);
            }
        });
    }
    setupStatusBarItem(text) {
        if (!ModeHandler._statusBarItem) {
            ModeHandler._statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left);
        }
        ModeHandler._statusBarItem.text = text || '';
        ModeHandler._statusBarItem.show();
    }
    // Return true if a new undo point should be created based on brackets and parenthesis
    createUndoPointForBrackets(vimState) {
        // }])> keys all start a new undo state when directly next to an {[(< opening character
        const key = vimState.recordedState.actionKeys[vimState.recordedState.actionKeys.length - 1];
        if (key === undefined) {
            return false;
        }
        if (vimState.currentMode === mode_1.ModeName.Insert) {
            // Check if the keypress is a closing bracket to a corresponding opening bracket right next to it
            let result = matcher_1.PairMatcher.nextPairedChar(vimState.cursorPosition, key, false);
            if (result !== undefined) {
                if (vimState.cursorPosition.compareTo(result) === 0) {
                    return true;
                }
            }
            result = matcher_1.PairMatcher.nextPairedChar(vimState.cursorPosition.getLeft(), key, true);
            if (result !== undefined) {
                if (vimState.cursorPosition.getLeftByCount(2).compareTo(result) === 0) {
                    return true;
                }
            }
        }
        return false;
    }
    dispose() {
        // do nothing
    }
}
ModeHandler.IsTesting = false;
exports.ModeHandler = ModeHandler;
//# sourceMappingURL=modeHandler.js.map