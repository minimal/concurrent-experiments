// adapted from http://swannodette.github.io/2013/08/24/es6-generators-and-csp
// live version: http://www.es6fiddle.net/hzhga1vm/
function go_(machine, step) {
  while(!step.done) {
    let [state, value] = step.value();

    switch (state) {
      case "park":
        setTimeout(() => go_(machine, step), 0);
        return;
      case "continue":
        step = machine.next(value);
        break;
      case "sleep":
        setTimeout(() => go_(machine, machine.next(value)), value);
        return;
    }
  }
}

function go(machine) {
  var gen = machine();
  go_(gen, gen.next());
}

function put(chan, val) {
  return () => {
    if(chan.length === 0) {
      chan.unshift(val);
      return ["continue", null];
    } else {
      return ["park", null];
    }
  };
}

function take(chan) {
  return () => {
    if(chan.length === 0) {
      return ["park", null];
    } else {
      return ["continue", chan.pop()];
    }
  };
}

function timeout(n) {
  return () => ["sleep", n];
}

function concur() {
  var numch = [];
  var stringch = [];
  go(function* (){
    let a = yield take(numch),
        b = yield take(numch),
        c = yield take(numch),
        d = a + b + c;
    yield put(stringch, a + " + " + b + " + " + c + " = " + d);
  });
  
  go(function* () {
    yield timeout(Math.floor(Math.random()*100));
    yield put(numch, 2 * 10);
  });
  	
  go(function* () {
    yield timeout(Math.floor(Math.random()*100));
    yield put(numch, 2 * 20);
    });
  go(function* () {
    yield timeout(Math.floor(Math.random()*100));
    yield put(numch, 30 + 40);
    });
 
  go(function* () {
    let res = yield take(stringch);
    console.log(res);
  });  
}

concur();
