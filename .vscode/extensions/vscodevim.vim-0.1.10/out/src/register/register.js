"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
const clipboard = require('copy-paste');
/**
 * There are two different modes of copy/paste in Vim - copy by character
 * and copy by line. Copy by line typically happens in Visual Line mode, but
 * also shows up in some other actions that work over lines (most noteably dd,
 * yy).
 */
(function (RegisterMode) {
    RegisterMode[RegisterMode["FigureItOutFromCurrentMode"] = 0] = "FigureItOutFromCurrentMode";
    RegisterMode[RegisterMode["CharacterWise"] = 1] = "CharacterWise";
    RegisterMode[RegisterMode["LineWise"] = 2] = "LineWise";
    RegisterMode[RegisterMode["BlockWise"] = 3] = "BlockWise";
})(exports.RegisterMode || (exports.RegisterMode = {}));
var RegisterMode = exports.RegisterMode;
;
class Register {
    static isValidRegister(register) {
        return register in Register.registers || /^[a-z0-9]+$/i.test(register);
    }
    /**
     * Puts content in a register. If none is specified, uses the default
     * register ".
     */
    static put(content, vimState) {
        const register = vimState.recordedState.registerName;
        if (!Register.isValidRegister(register)) {
            throw new Error(`Invalid register ${register}`);
        }
        if (register === '*') {
            clipboard.copy(content);
        }
        Register.registers[register] = {
            text: content,
            registerMode: vimState.effectiveRegisterMode(),
        };
    }
    /**
     * Gets content from a register. If none is specified, uses the default
     * register ".
     */
    static get(vimState) {
        return __awaiter(this, void 0, void 0, function* () {
            const register = vimState.recordedState.registerName;
            if (!Register.isValidRegister(register)) {
                throw new Error(`Invalid register ${register}`);
            }
            if (!Register.registers[register]) {
                Register.registers[register] = { text: "", registerMode: RegisterMode.CharacterWise };
            }
            /* Read from system clipboard */
            if (register === '*') {
                const text = yield new Promise((resolve, reject) => clipboard.paste((err, text) => {
                    if (err) {
                        reject(err);
                    }
                    else {
                        resolve(text);
                    }
                }));
                Register.registers[register].text = text;
            }
            return Register.registers[register];
        });
    }
}
/**
 * The '"' is the unnamed register.
 * The '*' is the special register for stroing into system clipboard.
 * TODO: Read-Only registers
 *  '.' register has the last inserted text.
 *  '%' register has the current file path.
 *  ':' is the most recently executed command.
 *  '#' is the name of last edited file. (low priority)
 */
Register.registers = {
    '"': { text: "", registerMode: RegisterMode.CharacterWise },
    '*': { text: "", registerMode: RegisterMode.CharacterWise }
};
exports.Register = Register;
//# sourceMappingURL=register.js.map