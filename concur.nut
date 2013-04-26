// squirrel
// uses co-operative coroutines, not os-threads
Scheduler <- class {
    current = null;
    runnable = [];
    constructor() {
    }
    function run() {
        while(runnable.len() > 0) {
            local co = runnable.remove(0);
            current = co;
            if(co.getstatus() == "idle"){
                co.call();
            } else { co.wakeup(); }
        }
    }
}
Queue <- class {
    queue = [];
    waiters = [];
    scheduler = null
    constructor(mainscheduler) {
        queue = [];
        waiters = [];
        scheduler = mainscheduler;
    }
    function put(item) {
        if(waiters.len() > 0) {
            local co = waiters.remove(0)
            scheduler.current = co
            scheduler.runnable.push(scheduler.current);
            co.wakeup(item);
            return;
        }
        queue.push(item);
    }
    function get() {
        if(queue.len() < 1) {
            waiters.push(scheduler.current);
            return ::suspend();
        }
        return queue.remove(0);
    }
}
function main() {
    local scheduler = Scheduler();
    local queue = Queue(scheduler);
    local result = null;
    local co = newthread(function(){
        local x = queue.get();
        local y = queue.get();
        local z = queue.get();
        result = x + " + " + y + " + " + z + " = " + (x + y + z);
    });
    scheduler.runnable.push(co)
    scheduler.runnable.push(newthread(@() queue.put(2 * 10)))
    scheduler.runnable.push(newthread(@() queue.put(2 * 20)))
    scheduler.runnable.push(newthread(@() queue.put(30 + 40)))
    scheduler.run();
    print(result);
}
main();
