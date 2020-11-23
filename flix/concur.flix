def collect(in: Channel[Int], out: Channel[String]): Unit & Impure =
  use StringBuilder.{new, appendInt32!, appendString!, toString};
  let s = new();
  let a = (<- in);
  let b = (<- in);
  let c = (<- in);
  appendInt32!(s, a);
  appendString!(s, " + ");
  appendInt32!(s, b);
  appendString!(s, " + ");
  appendInt32!(s, c);
  appendString!(s, " = ");
  appendInt32!(s, a + b + c);
  out <- toString(s);
  ()

def main(): String & Impure =
  let c = chan Int 0;
  let r = chan String 0;
  spawn { c <- 2 * 10 };
  spawn { c <- 2 * 20 };
  spawn { c <- 30 + 40 };
  spawn collect(c, r);
  <- r
