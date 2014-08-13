/*jshint esnext:true, node:true*/ //node --harmony javascript/concur-js-csp.js
"use strict";

var csp = require("js-csp");

csp.go(function* () {
  var numch = csp.chan();
  var stringch = csp.chan();

  csp.go(function*() {
    var a = yield csp.take(numch);
    var b = yield csp.take(numch);
    var c = yield csp.take(numch);
    var d = a + b + c;
    yield csp.put(stringch, a + " + " + b + " + " + c + " = " + d);
  });

  csp.go(function*() {
    yield csp.sleep(Math.floor(Math.random()*100));
    yield csp.put(numch, 2 * 10);
  });

  csp.go(function*() {
    yield csp.sleep(Math.floor(Math.random()*100));
    yield csp.put(numch, 2 * 20);
  });

  csp.go(function*() {
    yield csp.sleep(Math.floor(Math.random()*100));
    yield csp.put(numch, 30 + 40);
  });

  var res = yield csp.take(stringch);
  console.log(res);
});
