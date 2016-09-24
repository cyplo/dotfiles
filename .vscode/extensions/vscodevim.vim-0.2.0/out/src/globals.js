/**
 * globals.ts hold some globals used throughout the extension
 */
"use strict";
class Globals {
}
// true for running tests, false during regular runtime
Globals.isTesting = false;
Globals.WhitespaceRegExp = new RegExp("^ *$");
exports.Globals = Globals;
//# sourceMappingURL=globals.js.map