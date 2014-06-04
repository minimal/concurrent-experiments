using System;
using System.Threading.Tasks;
using System.Collections.Concurrent;

public class Concur
{
    BlockingCollection<int> results = new BlockingCollection<int>();

    public Concur() {
        Parallel.Invoke(
                this.test,
                () => { results.Add(2 * 10); },
                () => { results.Add(2 * 20); },
                () => { results.Add(30 + 40); }
            );
    }

    public void test() {
        var x = results.Take();
        var y = results.Take();
        var z = results.Take();
        Console.WriteLine("{0} + {1} + {2} = {3}", x, y, z, x + y + z);
    }

    public static void Main()
    {
        new Concur();
    }
}
