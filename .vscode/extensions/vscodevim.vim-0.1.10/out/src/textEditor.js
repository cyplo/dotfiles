"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
const vscode = require("vscode");
const modeHandler_1 = require('./mode/modeHandler');
const configuration_1 = require('./configuration/configuration');
const globals_1 = require('./globals');
class TextEditor {
    // TODO: Refactor args
    static insert(text, at = undefined, letVSCodeHandleKeystrokes = undefined) {
        return __awaiter(this, void 0, void 0, function* () {
            // If we insert "blah(" with default:type, VSCode will insert the closing ).
            // We *probably* don't want that to happen if we're inserting a lot of text.
            if (letVSCodeHandleKeystrokes === undefined) {
                letVSCodeHandleKeystrokes = text.length === 1;
            }
            if (at) {
                vscode.window.activeTextEditor.selection = new vscode.Selection(at, at);
            }
            if (modeHandler_1.ModeHandler.IsTesting || !letVSCodeHandleKeystrokes) {
                return vscode.window.activeTextEditor.edit(editBuilder => {
                    editBuilder.insert(vscode.window.activeTextEditor.selection.active, text);
                });
            }
            else {
                yield vscode.commands.executeCommand('default:type', { text });
            }
            return true;
        });
    }
    static insertAt(text, position) {
        return __awaiter(this, void 0, void 0, function* () {
            return vscode.window.activeTextEditor.edit(editBuilder => {
                editBuilder.insert(position, text);
            });
        });
    }
    static delete(range) {
        return __awaiter(this, void 0, void 0, function* () {
            return vscode.window.activeTextEditor.edit(editBuilder => {
                editBuilder.delete(range);
            });
        });
    }
    static backspace(position) {
        return __awaiter(this, void 0, void 0, function* () {
            if (position.character === 0) {
                if (position.line > 0) {
                    const prevEndOfLine = position.getPreviousLineBegin().getLineEnd();
                    yield TextEditor.delete(new vscode.Range(position.getPreviousLineBegin().getLineEnd(), position.getLineBegin()));
                    return prevEndOfLine;
                }
                else {
                    return position;
                }
            }
            else {
                let leftPosition = position.getLeft();
                if (position.getFirstLineNonBlankChar().character >= position.character) {
                    let tabStop = vscode.workspace.getConfiguration("editor").get("useTabStops", true);
                    if (tabStop) {
                        leftPosition = position.getLeftTabStop();
                    }
                }
                yield TextEditor.delete(new vscode.Range(position, leftPosition));
                return leftPosition;
            }
        });
    }
    static getDocumentVersion() {
        return vscode.window.activeTextEditor.document.version;
    }
    /**
     * Removes all text in the entire document.
     */
    static deleteDocument() {
        return __awaiter(this, void 0, void 0, function* () {
            const start = new vscode.Position(0, 0);
            const lastLine = vscode.window.activeTextEditor.document.lineCount - 1;
            const end = vscode.window.activeTextEditor.document.lineAt(lastLine).range.end;
            const range = new vscode.Range(start, end);
            return vscode.window.activeTextEditor.edit(editBuilder => {
                editBuilder.delete(range);
            });
        });
    }
    static replace(range, text) {
        return __awaiter(this, void 0, void 0, function* () {
            return vscode.window.activeTextEditor.edit(editBuilder => {
                editBuilder.replace(range, text);
            });
        });
    }
    static getAllText() {
        if (vscode.window.activeTextEditor) {
            return vscode.window.activeTextEditor.document.getText();
        }
        return "";
    }
    static readLine() {
        const lineNo = vscode.window.activeTextEditor.selection.active.line;
        return vscode.window.activeTextEditor.document.lineAt(lineNo).text;
    }
    static readLineAt(lineNo) {
        if (lineNo === null) {
            lineNo = vscode.window.activeTextEditor.selection.active.line;
        }
        if (lineNo >= vscode.window.activeTextEditor.document.lineCount) {
            throw new RangeError();
        }
        return vscode.window.activeTextEditor.document.lineAt(lineNo).text;
    }
    static getLineCount() {
        return vscode.window.activeTextEditor.document.lineCount;
    }
    static getLineAt(position) {
        return vscode.window.activeTextEditor.document.lineAt(position);
    }
    static getSelection() {
        return vscode.window.activeTextEditor.selection;
    }
    static getText(selection) {
        return vscode.window.activeTextEditor.document.getText(selection);
    }
    /**
     *  Retrieves the current word at position.
     *  If current position is whitespace, selects the right-closest word
     */
    static getWord(position) {
        let start = position;
        let end = position.getRight();
        const char = TextEditor.getText(new vscode.Range(start, end));
        if (globals_1.Globals.WhitespaceRegExp.test(char)) {
            start = position.getWordRight();
        }
        else {
            start = position.getWordLeft(true);
        }
        end = start.getCurrentWordEnd(true).getRight();
        const word = TextEditor.getText(new vscode.Range(start, end));
        if (globals_1.Globals.WhitespaceRegExp.test(word)) {
            return undefined;
        }
        return word;
    }
    static isFirstLine(position) {
        return position.line === 0;
    }
    static isLastLine(position) {
        return position.line === (vscode.window.activeTextEditor.document.lineCount - 1);
    }
    static getIndentationLevel(line) {
        let tabSize = configuration_1.Configuration.getInstance().tabstop;
        let firstNonWhiteSpace = line.match(/^\s*/)[0].length;
        let visibleColumn = 0;
        if (firstNonWhiteSpace >= 0) {
            for (const char of line.substring(0, firstNonWhiteSpace)) {
                switch (char) {
                    case '\t':
                        visibleColumn += tabSize;
                        break;
                    case ' ':
                        visibleColumn += 1;
                        break;
                    default:
                        break;
                }
            }
        }
        else {
            return -1;
        }
        return visibleColumn;
    }
    static setIndentationLevel(line, screenCharacters) {
        let tabSize = configuration_1.Configuration.getInstance().tabstop;
        let insertTabAsSpaces = configuration_1.Configuration.getInstance().expandtab;
        if (screenCharacters < 0) {
            screenCharacters = 0;
        }
        let indentString = "";
        if (insertTabAsSpaces) {
            indentString += new Array(screenCharacters + 1).join(" ");
        }
        else {
            if (screenCharacters / tabSize > 0) {
                indentString += new Array(Math.floor(screenCharacters / tabSize) + 1).join("\t");
            }
            indentString += new Array(screenCharacters % tabSize + 1).join(" ");
        }
        let firstNonWhiteSpace = line.match(/^\s*/)[0].length;
        return indentString + line.substring(firstNonWhiteSpace, line.length);
    }
}
exports.TextEditor = TextEditor;
//# sourceMappingURL=textEditor.js.map