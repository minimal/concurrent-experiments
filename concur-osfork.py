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

for val in (2 * 10, 2 * 20, 30 + 40):
    if not os.fork():
        [os.close(i) for i in (numbers_r, result_r, result_w)]
        pickle.dump(val, os.fdopen(numbers_w, 'wb'))
        os._exit(0)

print pickle.load(os.fdopen(result_r, 'rb'))
