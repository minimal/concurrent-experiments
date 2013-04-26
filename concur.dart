import 'dart:isolate';

collate() {
  var receiver;
  port.receive((a, reply) {
    port.receive((b, reply) {
      port.receive((c, reply) {
        var d = a + b + c;
        reply.send("$a + $b + $c = $d");
      });
    });
  });
}

worker(){
  port.receive((msg, reply) {
    if (msg[0] == "add") {
      reply.send(msg[1] + msg[2]);
    } else if (msg[0] == "mul") {
      reply.send(msg[1] *  msg[2]);
    }
  });
}

main() {
  var resultPort = spawnFunction(collate);
  var adderPort = spawnFunction(worker);
  adderPort.call(["mul", 2, 10, resultPort]).then((reply) => resultPort.call(reply).then((reply) => print(reply)));
  adderPort.call(["mul", 2, 20, resultPort]).then((reply) => resultPort.call(reply).then((reply) => print(reply)));
  adderPort.call(["add", 30, 40, resultPort]).then((reply) => resultPort.call(reply).then((reply) => print(reply)));
}
