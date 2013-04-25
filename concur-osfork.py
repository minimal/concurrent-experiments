from operator import mul, add
import os
import pickle

numbers_r, numbers_w = os.pipe()
result_r, result_w = os.pipe()

if not os.fork():
    [os.close(i) for i in (numbers_w, result_r)]
    inp = os.fdopen(numbers_r, 'rb')
    x = pickle.load(inp)
    y = pickle.load(inp)
    z = pickle.load(inp)
    pickle.dump("%d + %d + %d = %d" % (x, y, z, x + y + z),
                os.fdopen(result_w, 'wb'))
    os._exit(0)

for val in ((mul, 2, 10), (mul, 2, 20), (add, 30, 40)):
    if not os.fork():
        [os.close(i) for i in (numbers_r, result_r, result_w)]
        val = val[0](*val[1:])
        pickle.dump(val, os.fdopen(numbers_w, 'wb'))
        os._exit(0)

print pickle.load(os.fdopen(result_r, 'rb'))
