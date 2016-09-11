"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
const vscode = require('vscode');
/**
 * Every Vim option we support should
 * 1. Be added to contribution section of `package.json`.
 * 2. Named as `vim.{optionName}`, `optionName` is the name we use in Vim.
 * 3. Define a public property in `Configuration `with the same name and a default value.
 *    Or define a private propery and define customized Getter/Setter accessors for it.
 *    Always remember to decorate Getter accessor as @enumerable()
 * 4. If user doesn't set the option explicitly
 *    a. we don't have a similar setting in Code, initialize the option as default value.
 *    b. we have a similar setting in Code, use Code's setting.
 *
 * Vim option override sequence.
 * 1. `:set {option}` on the fly
 * 2. TODO .vimrc.
 * 2. `vim.{option}`
 * 3. VS Code configuration
 * 4. VSCodeVim flavored Vim option default values
 *
 */
class Configuration {
    constructor() {
        this.useSolidBlockCursor = false;
        this.useSystemClipboard = false;
        this.useCtrlKeys = false;
        this.scroll = 20;
        this.hlsearch = false;
        this.ignorecase = true;
        this.smartcase = true;
        this.autoindent = true;
        this.tabstop = undefined;
        this.expandtab = undefined;
        this.iskeyword = "/\\()\"':,.;<>~!@#$%^&*|+=[]{}`?-";
        /**
         * Load Vim options from User Settings.
         */
        let vimOptions = vscode.workspace.getConfiguration("vim");
        /* tslint:disable:forin */
        // Disable forin rule here as we make accessors enumerable.`
        for (const option in this) {
            const vimOptionValue = vimOptions[option];
            if (vimOptionValue !== null && vimOptionValue !== undefined) {
                this[option] = vimOptionValue;
            }
        }
    }
    static getInstance() {
        if (Configuration._instance == null) {
            Configuration._instance = new Configuration();
        }
        return Configuration._instance;
    }
}
__decorate([
    overlapSetting({ codeName: "tabSize", default: 8 })
], Configuration.prototype, "tabstop", void 0);
__decorate([
    overlapSetting({ codeName: "insertSpaces", default: false })
], Configuration.prototype, "expandtab", void 0);
exports.Configuration = Configuration;
function overlapSetting(args) {
    return function (target, propertyKey) {
        Object.defineProperty(target, propertyKey, {
            get: function () {
                if (this["_" + propertyKey] !== undefined) {
                    return this["_" + propertyKey];
                }
                return vscode.workspace.getConfiguration("editor").get(args.codeName, args.default);
            },
            set: function (value) {
                this["_" + propertyKey] = value;
            },
            enumerable: true,
            configurable: true
        });
    };
}
//# sourceMappingURL=configuration.js.map