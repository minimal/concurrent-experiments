// supercollider
(
var queue = List[];
var queue_sem = Semaphore(1);
var get = {
	var res = nil;
	while({res == nil}, {queue_sem.wait; if(queue.size > 0, {res = queue.pop})});
	res;
};
var put = {arg item;
	queue.add(item);
	queue_sem.signal;
};
r = { var x = get.value;
	  var y = get.value;
	  var z = get.value;
      postf("% + % + % = %", x, y, z, x + y + z); }.fork;
{ put.value(2 * 10) }.fork;
{ put.value(2 * 20) }.fork;
{ put.value(30 + 40) }.fork;
r.value.postln;
)
