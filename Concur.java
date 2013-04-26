import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;


public class Concur {
    
    public static void main(final String[] argv) {

        final ExecutorService service = Executors.newFixedThreadPool(4);
        final List<Future<Integer>> tasks = new LinkedList<Future<Integer>>();

        for (int i = 1; i <= 3; ++i) {
            tasks.add(service.submit(new MulWorker(i * 10)));
        }

        try {
            Future<String> sumWorker = service.submit(new SumWorker(tasks));
            String sum = sumWorker.get();
            System.out.println(sum);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        service.shutdownNow();
    }
}


class MulWorker implements Callable<Integer> {

    private int n;

    public MulWorker(int n) {
        this.n = n;
    }

    public Integer call() {
        return n * 2;
    }
}


class SumWorker implements Callable<String> {

    private List<Future<Integer>> tasks;

    public SumWorker(List<Future<Integer>> tasks) {
        this.tasks = tasks;
    }

    public String call() {
        int sum = 0;
        for (Future<Integer> task : tasks) {
            try {
                sum += task.get();
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }
        return Integer.toString(sum);
    }
}