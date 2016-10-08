"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
// XXX: use graceful-fs ??
const fs = require('fs');
const path = require('path');
const vscode = require('vscode');
const node = require('../node');
const util = require('../../util');
//
//  Implements :write
//  http://vimdoc.sourceforge.net/htmldoc/editing.html#:write
//
class WriteCommand extends node.CommandBase {
    constructor(args) {
        super();
        this._name = 'write';
        this._shortName = 'w';
        this._arguments = args;
    }
    get arguments() {
        return this._arguments;
    }
    execute(modeHandler) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.arguments.opt) {
                util.showError("Not implemented.");
                return;
            }
            else if (this.arguments.file) {
                util.showError("Not implemented.");
                return;
            }
            else if (this.arguments.append) {
                util.showError("Not implemented.");
                return;
            }
            else if (this.arguments.cmd) {
                util.showError("Not implemented.");
                return;
            }
            if (this.activeTextEditor.document.isUntitled) {
                yield vscode.commands.executeCommand("workbench.action.files.save");
                return;
            }
            try {
                fs.accessSync(this.activeTextEditor.document.fileName, fs.W_OK);
                return this.save(modeHandler);
            }
            catch (accessErr) {
                if (this.arguments.bang) {
                    fs.chmod(this.activeTextEditor.document.fileName, 666, (e) => {
                        if (e) {
                            modeHandler.setupStatusBarItem(e.message);
                        }
                        else {
                            return this.save(modeHandler);
                        }
                    });
                }
                else {
                    modeHandler.setupStatusBarItem(accessErr.message);
                }
            }
        });
    }
    save(modeHandler) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.activeTextEditor.document.save().then((ok) => {
                modeHandler.setupStatusBarItem('"' + path.basename(this.activeTextEditor.document.fileName) +
                    '" ' + this.activeTextEditor.document.lineCount + 'L ' +
                    this.activeTextEditor.document.getText().length + 'C written');
            }, (e) => modeHandler.setupStatusBarItem(e));
        });
    }
}
exports.WriteCommand = WriteCommand;
//# sourceMappingURL=write.js.map