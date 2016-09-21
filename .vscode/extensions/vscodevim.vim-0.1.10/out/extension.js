'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
/**
 * Extension.ts is a lightweight wrapper around ModeHandler. It converts key
 * events to their string names and passes them on to ModeHandler via
 * handleKeyEvent().
 */
const vscode = require('vscode');
const _ = require("lodash");
const main_1 = require('./src/cmd_line/main');
const modeHandler_1 = require('./src/mode/modeHandler');
const taskQueue_1 = require('./src/taskQueue');
const position_1 = require('./src/motion/position');
const globals_1 = require('./src/globals');
const notation_1 = require('./src/notation');
const packagejson = require('../package.json'); // out/../package.json
class EditorIdentity {
    constructor(textEditor) {
        this._fileName = textEditor && textEditor.document.fileName || "";
        this._viewColumn = textEditor && textEditor.viewColumn || vscode.ViewColumn.One;
    }
    get fileName() {
        return this._fileName;
    }
    get viewColumn() {
        return this._viewColumn;
    }
    hasSameBuffer(identity) {
        return this.fileName === identity.fileName;
    }
    isEqual(identity) {
        return this.fileName === identity.fileName && this.viewColumn === identity.viewColumn;
    }
    toString() {
        return this.fileName + this.viewColumn;
    }
}
exports.EditorIdentity = EditorIdentity;
let extensionContext;
/**
 * Note: We can't initialize modeHandler here, or even inside activate(), because some people
 * see a bug where VSC hasn't fully initialized yet, which pretty much breaks VSCodeVim entirely.
 */
let modeHandlerToEditorIdentity = {};
let previousActiveEditorId = new EditorIdentity();
let taskQueue = new taskQueue_1.TaskQueue();
function getAndUpdateModeHandler() {
    return __awaiter(this, void 0, void 0, function* () {
        const oldHandler = modeHandlerToEditorIdentity[previousActiveEditorId.toString()];
        const activeEditorId = new EditorIdentity(vscode.window.activeTextEditor);
        if (!modeHandlerToEditorIdentity[activeEditorId.toString()]) {
            const newModeHandler = new modeHandler_1.ModeHandler(activeEditorId.fileName);
            modeHandlerToEditorIdentity[activeEditorId.toString()] = newModeHandler;
            extensionContext.subscriptions.push(newModeHandler);
        }
        const handler = modeHandlerToEditorIdentity[activeEditorId.toString()];
        if (previousActiveEditorId.hasSameBuffer(activeEditorId)) {
            if (!previousActiveEditorId.isEqual(activeEditorId)) {
                // We have opened two editors, working on the same file.
                previousActiveEditorId = activeEditorId;
                handler.vimState.cursorPosition = position_1.Position.FromVSCodePosition(vscode.window.activeTextEditor.selection.end);
                handler.vimState.cursorStartPosition = position_1.Position.FromVSCodePosition(vscode.window.activeTextEditor.selection.start);
            }
        }
        else {
            previousActiveEditorId = activeEditorId;
            yield handler.updateView(handler.vimState);
        }
        if (oldHandler && oldHandler.vimState.focusChanged) {
            oldHandler.vimState.focusChanged = false;
            handler.vimState.focusChanged = true;
        }
        return handler;
    });
}
exports.getAndUpdateModeHandler = getAndUpdateModeHandler;
class CompositionState {
    constructor() {
        this.isInComposition = false;
        this.composingText = "";
    }
}
function activate(context) {
    return __awaiter(this, void 0, void 0, function* () {
        extensionContext = context;
        let compositionState = new CompositionState();
        vscode.window.onDidChangeActiveTextEditor(handleActiveEditorChange, this);
        vscode.workspace.onDidChangeTextDocument((event) => {
            /**
             * Change from vscode editor should set document.isDirty to true but they initially don't!
             * There is a timing issue in vscode codebase between when the isDirty flag is set and
             * when registered callbacks are fired. https://github.com/Microsoft/vscode/issues/11339
             */
            setTimeout(() => {
                if (!event.document.isDirty && !event.document.isUntitled) {
                    handleContentChangedFromDisk(event.document);
                }
            }, 0);
        });
        registerCommand(context, 'type', (args) => __awaiter(this, void 0, void 0, function* () {
            if (!vscode.window.activeTextEditor) {
                return;
            }
            taskQueue.enqueueTask({
                promise: () => __awaiter(this, void 0, void 0, function* () {
                    const mh = yield getAndUpdateModeHandler();
                    if (compositionState.isInComposition) {
                        compositionState.composingText += args.text;
                    }
                    else {
                        yield mh.handleKeyEvent(args.text);
                    }
                }),
                isRunning: false
            });
        }));
        registerCommand(context, 'replacePreviousChar', (args) => __awaiter(this, void 0, void 0, function* () {
            if (!vscode.window.activeTextEditor) {
                return;
            }
            taskQueue.enqueueTask({
                promise: () => __awaiter(this, void 0, void 0, function* () {
                    const mh = yield getAndUpdateModeHandler();
                    if (compositionState.isInComposition) {
                        compositionState.composingText = compositionState.composingText.substr(0, compositionState.composingText.length - args.replaceCharCnt) + args.text;
                    }
                    else {
                        yield vscode.commands.executeCommand('default:replacePreviousChar', {
                            text: args.text,
                            replaceCharCnt: args.replaceCharCnt
                        });
                        mh.vimState.cursorPosition = position_1.Position.FromVSCodePosition(vscode.window.activeTextEditor.selection.start);
                        mh.vimState.cursorStartPosition = position_1.Position.FromVSCodePosition(vscode.window.activeTextEditor.selection.start);
                    }
                }),
                isRunning: false
            });
        }));
        registerCommand(context, 'compositionStart', (args) => __awaiter(this, void 0, void 0, function* () {
            if (!vscode.window.activeTextEditor) {
                return;
            }
            taskQueue.enqueueTask({
                promise: () => __awaiter(this, void 0, void 0, function* () {
                    const mh = yield getAndUpdateModeHandler();
                    compositionState.isInComposition = true;
                }),
                isRunning: false
            });
        }));
        registerCommand(context, 'compositionEnd', (args) => __awaiter(this, void 0, void 0, function* () {
            if (!vscode.window.activeTextEditor) {
                return;
            }
            taskQueue.enqueueTask({
                promise: () => __awaiter(this, void 0, void 0, function* () {
                    const mh = yield getAndUpdateModeHandler();
                    let text = compositionState.composingText;
                    compositionState = new CompositionState();
                    yield mh.handleMultipleKeyEvents(text.split(""));
                }),
                isRunning: false
            });
        }));
        registerCommand(context, 'extension.showCmdLine', () => {
            main_1.showCmdLine("", modeHandlerToEditorIdentity[new EditorIdentity(vscode.window.activeTextEditor).toString()]);
        });
        for (let { key } of packagejson.contributes.keybindings) {
            let bracketedKey = notation_1.AngleBracketNotation.Normalize(key);
            registerCommand(context, `extension.vim_${key.toLowerCase()}`, () => handleKeyEvent(`${bracketedKey}`));
        }
        // Initialize mode handler for current active Text Editor at startup.
        if (vscode.window.activeTextEditor) {
            let mh = yield getAndUpdateModeHandler();
            mh.updateView(mh.vimState, false);
        }
    });
}
exports.activate = activate;
function registerCommand(context, command, callback) {
    let disposable = vscode.commands.registerCommand(command, callback);
    context.subscriptions.push(disposable);
}
function handleKeyEvent(key) {
    return __awaiter(this, void 0, void 0, function* () {
        const mh = yield getAndUpdateModeHandler();
        taskQueue.enqueueTask({
            promise: () => __awaiter(this, void 0, void 0, function* () { yield mh.handleKeyEvent(key); }),
            isRunning: false
        });
    });
}
function handleContentChangedFromDisk(document) {
    _.filter(modeHandlerToEditorIdentity, modeHandler => modeHandler.fileName === document.fileName)
        .forEach(modeHandler => {
        modeHandler.vimState.historyTracker.clear();
    });
}
function handleActiveEditorChange() {
    return __awaiter(this, void 0, void 0, function* () {
        // Don't run this event handler during testing
        if (globals_1.Globals.isTesting) {
            return;
        }
        taskQueue.enqueueTask({
            promise: () => __awaiter(this, void 0, void 0, function* () {
                if (vscode.window.activeTextEditor !== undefined) {
                    const mh = yield getAndUpdateModeHandler();
                    mh.updateView(mh.vimState, false);
                }
            }),
            isRunning: false
        });
    });
}
process.on('unhandledRejection', function (reason, p) {
    console.log("Unhandled Rejection at: Promise ", p, " reason: ", reason);
});
//# sourceMappingURL=extension.js.map