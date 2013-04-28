from operator import mul, add
import os
import pickle
import select

numbers = [os.pipe() for i in xrange(3)]
readers = [os.fdopen(i[0], 'rb') for i in numbers]
result_r, result_w = os.pipe()


def get_ready():
    return select.select(readers, [], [])[0][0]

if not os.fork():
    x = pickle.load(get_ready())
    y = pickle.load(get_ready())
    z = pickle.load(get_ready())
    pickle.dump("%d + %d + %d = %d" % (x, y, z, x + y + z),
                os.fdopen(result_w, 'wb'))
    os._exit(0)

for i, val in enumerate([(mul, 2, 10), (mul, 2, 20), (add, 30, 40)]):
    if not os.fork():
        val = val[0](*val[1:])
        pickle.dump(val, os.fdopen(numbers[i][1], 'wb'))
        os._exit(0)

print pickle.load(os.fdopen(result_r, 'rb'))
