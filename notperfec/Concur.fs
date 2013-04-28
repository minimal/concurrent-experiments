let list123 =
        Async.Parallel [
            async { return 10 * 2 }
            async { return 20 * 2 }
            async { return 30 + 40 } ]
        |> Async.RunSynchronously

let sum = list123 |> Array.fold (fun x y -> x + y) 0
printf "%d + %d + %d = %d\n" list123.[0] list123.[1] list123.[2] sum
