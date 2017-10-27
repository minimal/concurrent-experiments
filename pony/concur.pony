use "format"
use "promises"

actor Proc
  let vals: Array[I64] = Array[I64](3)
  let ret: Promise[String]

  new create(p : Promise[String]) =>
      ret = p

  fun disp(v : I64) : String =>
      Format.int[I64](v)

  be apply(v : I64) =>
    vals.push(v)
    match vals.size()
    | 3 => try
             ret(disp(vals(0)?) + " + " + disp(vals(1)?) + " + " + disp(vals(2)?) + " = "
               + disp(vals(0)? + vals(1)? + vals(2)?))
           end
    end

actor Main
  new create(env: Env) =>
    let p = Promise[String]
    let proc = Proc(p)
    p.next[None]({(r : String) => env.out.print(r)})
    (object
      be apply() => proc(2 * 10)
     end)()
    (object
      be apply() => proc(2 * 20)
     end)()
    (object
      be apply() => proc(30 + 40)
     end)()