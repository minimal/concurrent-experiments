""" Uses explicit continuation-passing to reify continuations
    and build coroutines from them.

"""

# our continuation type, used in the run-queue to determine
# if a coroutine cas finished or simply been yielded.
cont = type('Cont', (object, ),
            {'__init__': lambda s, f: setattr(s, 'runCont', f),
             '__call__': lambda s, c: s.runCont(c), })

id = lambda a: a
pure = lambda v: lambda c: c(v)
bind = lambda a, b: lambda c: a(lambda c2: b(c2)(c))
callcc = lambda f: lambda c: f(lambda c2: lambda _: c(c2))(c)
do = lambda a, *b: reduce(bind, b, a)

# our numbers channel:
numbers = []
# if `numbers` is empty then it breaks out of the coroutine
# using the passed continuation returning a continuation
# that, when called, retries and continues the coroutine if
# an item is available.
get = lambda cc: lambda c: (
    cc(cont(lambda c2: get(cc)(lambda v: c2(c(v)))))(c)
    if not numbers else c(numbers.pop(0)))

# the supply of numbers for the channel
p1 = lambda c: c(numbers.append(2 * 10))
p2 = lambda c: c(numbers.append(2 * 20))
p3 = lambda c: c(numbers.append(30 + 40))

format = lambda x, y, z: "%d + %d + %d = %d" % (x, y, z, x + y + z)
# gets the current-continuation (representing the entire procedure)
# from `callcc` to pass to `get` and each time the continuation
# captures the result of `get` in the parameter of the lambda for
# usage when all 3 have been obtained.
proc = callcc(lambda cc: do(
    get(cc), lambda x: do(
        get(cc), lambda y: do(
            get(cc), lambda z: cc(format(x, y, z))))))


# our run-queue. calls each item with `id` as continuation to
# obtain result / further continuation.
# if further continuation received put it into the queue and
# move on.
def run(*tasks):
    runnable = list(tasks)
    r = None
    while runnable:
        c = runnable.pop(0)
        r = c(id)
        if isinstance(r, cont):
            runnable.append(r)
    return r


# print the result of the run-queue.
# we pass in `proc` first to show that it suspends on the results
# of the other p* coroutines.
print run(proc, p1, p2, p3)
