import 'dart:isolate';

collate() {
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
  spawnFunction(worker).call(["mul", 2, 10]).then(
      (reply) => resultPort.call(reply).then((reply) => print(reply)));
  spawnFunction(worker).call(["mul", 2, 20]).then(
      (reply) => resultPort.call(reply).then((reply) => print(reply)));
  spawnFunction(worker).call(["add", 30, 40]).then(
      (reply) => resultPort.call(reply).then((reply) => print(reply)));
}
