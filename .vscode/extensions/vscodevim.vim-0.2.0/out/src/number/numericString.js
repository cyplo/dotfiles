"use strict";
class NumericString {
    constructor(value, radix, prefix) {
        this.value = value;
        this.radix = radix;
        this.prefix = prefix;
    }
    static parse(input) {
        for (const { regex, base, prefix } of NumericString.matchings) {
            const match = regex.exec(input);
            if (match == null) {
                continue;
            }
            return new NumericString(parseInt(match[0], base), base, prefix);
        }
        return null;
    }
    toString() {
        return this.prefix + this.value.toString(this.radix);
    }
}
NumericString.matchings = [
    { regex: /^([-+])?0([0-7]+)$/, base: 8, prefix: "0" },
    { regex: /^([-+])?(\d+)$/, base: 10, prefix: "" },
    { regex: /^([-+])?0x([\da-fA-F]+)$/, base: 16, prefix: "0x" },
];
exports.NumericString = NumericString;
//# sourceMappingURL=numericString.js.map