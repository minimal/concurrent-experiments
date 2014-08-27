/*jshint esnext:true, node:true*/ //node --harmony javascript/concur-js-csp.js
"use strict";

var csp = require("js-csp");

csp.go(function* () {
  let numch = csp.chan(),
      stringch = csp.chan();

  csp.go(function*() {
    let a = yield csp.take(numch),
        b = yield csp.take(numch),
        c = yield csp.take(numch),
        d = a + b + c;
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

  let res = yield csp.take(stringch);
  console.log(res);
});
