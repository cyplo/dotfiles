"use strict";
const quit_1 = require('./subparsers/quit');
const write_1 = require('./subparsers/write');
const writequit_1 = require('./subparsers/writequit');
const tabCmd = require('./subparsers/tab');
const fileCmd = require('./subparsers/file');
const setoptions_1 = require('./subparsers/setoptions');
const substitute_1 = require('./subparsers/substitute');
// maps command names to parsers for said commands.
exports.commandParsers = {
    w: write_1.parseWriteCommandArgs,
    write: write_1.parseWriteCommandArgs,
    quit: quit_1.parseQuitCommandArgs,
    q: quit_1.parseQuitCommandArgs,
    wq: writequit_1.parseWriteQuitCommandArgs,
    writequit: writequit_1.parseWriteQuitCommandArgs,
    tabn: tabCmd.parseTabNCommandArgs,
    tabnext: tabCmd.parseTabNCommandArgs,
    tabp: tabCmd.parseTabPCommandArgs,
    tabprevious: tabCmd.parseTabPCommandArgs,
    tabN: tabCmd.parseTabPCommandArgs,
    tabNext: tabCmd.parseTabPCommandArgs,
    tabfirst: tabCmd.parseTabFirstCommandArgs,
    tabfir: tabCmd.parseTabFirstCommandArgs,
    tablast: tabCmd.parseTabLastCommandArgs,
    tabl: tabCmd.parseTabLastCommandArgs,
    tabe: tabCmd.parseTabNewCommandArgs,
    tabedit: tabCmd.parseTabNewCommandArgs,
    tabnew: tabCmd.parseTabNewCommandArgs,
    tabclose: tabCmd.parseTabCloseCommandArgs,
    tabc: tabCmd.parseTabCloseCommandArgs,
    tabo: tabCmd.parseTabOnlyCommandArgs,
    tabonly: tabCmd.parseTabOnlyCommandArgs,
    tabm: tabCmd.parseTabMovementCommandArgs,
    e: fileCmd.parseEditFileCommandArgs,
    s: substitute_1.parseSubstituteCommandArgs,
    vsp: fileCmd.parseEditFileInNewWindowCommandArgs,
    vsplit: fileCmd.parseEditFileInNewWindowCommandArgs,
    vne: fileCmd.parseEditNewFileInNewWindowCommandArgs,
    vnew: fileCmd.parseEditNewFileInNewWindowCommandArgs,
    set: setoptions_1.parseOptionsCommandArgs,
    se: setoptions_1.parseOptionsCommandArgs
};
//# sourceMappingURL=subparser.js.map