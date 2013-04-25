// supercollider
(
var queue = List[];
var waiting = List[];
var runnable = List[];
var get = {
	if (queue.size < 1,
		{waiting.add(thisThread); nil.yield},
		{queue.pop})
};
var put = {arg item;
	if (waiting.size > 0,
		{runnable.add(List[waiting.pop, item])},
		{queue.add(item)})};

r = Routine {
	var x = get.value;
	var y = get.value;
	var z = get.value;
	postf("% + % + % = %", x, y, z, x + y + z);
};
runnable.add(List[r, nil]);
runnable.add(List[Routine {put.value(2 * 10)}, nil]);
runnable.add(List[Routine {put.value(2 * 20)}, nil]);
runnable.add(List[Routine {put.value(30 + 40)}, nil]);
while({runnable.size > 0}, {
	var item = runnable.pop;
	var res = item.at(0).next(item.at(1));
});
r.value.postln;
)
