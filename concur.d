import std.stdio, std.concurrency, std.c.stdio, std.format, std.array;
 
void recieverFunc(Tid tid)
{
    int a, b, c = 0;
    receive( (int msg) { a = msg; } );
    receive( (int msg) { b = msg; } );
    receive( (int msg) { c = msg; } );

    auto writer = appender!string();
    formattedWrite(writer, "%d + %d + %d = %d", a, b, c, a + b + c);
    send(tid, writer.data);
}

void add(Tid tid, int x, int y) { tid.send(x + y); }
void mul(Tid tid, int x, int y) { tid.send(x * y); }
 
void main()
{
    auto tid = spawn(&recieverFunc, thisTid);
    spawn(&mul, tid, 2, 10);
    spawn(&mul, tid, 2, 20);
    spawn(&add, tid, 30, 40);
 
    auto response = receiveOnly!(string);
    writeln(response);
}
