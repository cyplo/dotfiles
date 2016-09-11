/* tslint:disable:no-bitwise */
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
const node = require("../node");
const token = require('../token');
const textEditor_1 = require("../../textEditor");
/**
 * The flags that you can use for the substitute commands:
 * [&] Must be the first one: Keep the flags from the previous substitute command.
 * [c] Confirm each substitution.
 * [e] When the search pattern fails, do not issue an error message and, in
 *     particular, continue in maps as if no error occurred.
 * [g] Replace all occurrences in the line.  Without this argument, replacement
 *     occurs only for the first occurrence in each line.
 * [i] Ignore case for the pattern.
 * [I] Don't ignore case for the pattern.
 * [n] Report the number of matches, do not actually substitute.
 * [p] Print the line containing the last substitute.
 * [#] Like [p] and prepend the line number.
 * [l] Like [p] but print the text like |:list|.
 * [r] When the search pattern is empty, use the previously used search pattern
 *     instead of the search pattern from the last substitute or ":global".
 */
(function (SubstituteFlags) {
    SubstituteFlags[SubstituteFlags["None"] = 0] = "None";
    SubstituteFlags[SubstituteFlags["KeepPreviousFlags"] = 1] = "KeepPreviousFlags";
    SubstituteFlags[SubstituteFlags["ConfirmEach"] = 2] = "ConfirmEach";
    SubstituteFlags[SubstituteFlags["SuppressError"] = 4] = "SuppressError";
    SubstituteFlags[SubstituteFlags["ReplaceAll"] = 8] = "ReplaceAll";
    SubstituteFlags[SubstituteFlags["IgnoreCase"] = 16] = "IgnoreCase";
    SubstituteFlags[SubstituteFlags["NoIgnoreCase"] = 32] = "NoIgnoreCase";
    SubstituteFlags[SubstituteFlags["PrintCount"] = 64] = "PrintCount";
    SubstituteFlags[SubstituteFlags["PrintLastMatchedLine"] = 128] = "PrintLastMatchedLine";
    SubstituteFlags[SubstituteFlags["PrintLastMatchedLineWithNumber"] = 256] = "PrintLastMatchedLineWithNumber";
    SubstituteFlags[SubstituteFlags["PrintLastMatchedLineWithList"] = 512] = "PrintLastMatchedLineWithList";
    SubstituteFlags[SubstituteFlags["UsePreviousPattern"] = 1024] = "UsePreviousPattern";
})(exports.SubstituteFlags || (exports.SubstituteFlags = {}));
var SubstituteFlags = exports.SubstituteFlags;
class SubstituteCommand extends node.CommandBase {
    constructor(args) {
        super();
        this._name = 'search';
        this._shortName = 's';
        this._arguments = args;
    }
    get arguments() {
        return this._arguments;
    }
    getRegex(args) {
        let jsRegexFlags = "";
        if (args.flags & SubstituteFlags.ReplaceAll) {
            jsRegexFlags += "g";
        }
        if (args.flags & SubstituteFlags.IgnoreCase) {
            jsRegexFlags += "i";
        }
        return new RegExp(args.pattern, jsRegexFlags);
    }
    replaceTextAtLine(line, regex) {
        return __awaiter(this, void 0, void 0, function* () {
            const originalContent = textEditor_1.TextEditor.readLineAt(line);
            const newContent = originalContent.replace(regex, this._arguments.replace);
            if (originalContent !== newContent) {
                yield textEditor_1.TextEditor.replace(new vscode.Range(line, 0, line, originalContent.length), newContent);
            }
        });
    }
    execute() {
        return __awaiter(this, void 0, void 0, function* () {
            const regex = this.getRegex(this._arguments);
            const selection = vscode.window.activeTextEditor.selection;
            const line = selection.start.isBefore(selection.end) ? selection.start.line : selection.end.line;
            yield this.replaceTextAtLine(line, regex);
        });
    }
    executeWithRange(modeHandler, range) {
        return __awaiter(this, void 0, void 0, function* () {
            let startLine;
            let endLine;
            if (range.left[0].type === token.TokenType.Percent) {
                startLine = new vscode.Position(0, 0);
                endLine = new vscode.Position(textEditor_1.TextEditor.getLineCount() - 1, 0);
            }
            else {
                startLine = range.lineRefToPosition(vscode.window.activeTextEditor, range.left);
                endLine = range.lineRefToPosition(vscode.window.activeTextEditor, range.right);
            }
            if (this._arguments.count && this._arguments.count >= 0) {
                startLine = endLine;
                endLine = new vscode.Position(endLine.line + this._arguments.count - 1, 0);
            }
            // TODO: Global Setting.
            // TODO: There are differencies between Vim Regex and JS Regex.
            let regex = this.getRegex(this._arguments);
            for (let currentLine = startLine.line; currentLine <= endLine.line && currentLine < textEditor_1.TextEditor.getLineCount(); currentLine++) {
                yield this.replaceTextAtLine(currentLine, regex);
            }
        });
    }
}
exports.SubstituteCommand = SubstituteCommand;
//# sourceMappingURL=substitute.js.map