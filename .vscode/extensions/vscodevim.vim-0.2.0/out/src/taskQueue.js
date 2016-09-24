"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
const _ = require("lodash");
/**
 * TaskQueue
 *
 * Enqueue promises here. They will be run sequentially.
 */
class TaskQueue {
    constructor() {
        this._tasks = [];
    }
    _runTasks() {
        return __awaiter(this, void 0, void 0, function* () {
            while (this._tasks.length > 0) {
                let task = this._tasks[0];
                try {
                    task.isRunning = true;
                    yield task.promise();
                    task.isRunning = false;
                }
                catch (e) {
                    console.log(e);
                    console.log(e.stack);
                }
                finally {
                    this.removeTask(task);
                }
            }
        });
    }
    /**
     * Removes a task from the task queue.
     *
     * (Keep in mind that if the task is already running, the semantics of
     * promises don't allow you to stop it.)
     */
    removeTask(task) {
        this._tasks.splice(_.findIndex(this._tasks, t => t === task), 1);
    }
    /**
     * Adds a task to the task queue.
     */
    enqueueTask(task) {
        let otherTaskRunning = _.filter(this._tasks, x => x.isRunning).length > 0;
        this._tasks.push(task);
        if (!otherTaskRunning) {
            this._runTasks();
        }
    }
}
exports.TaskQueue = TaskQueue;
//# sourceMappingURL=taskQueue.js.map