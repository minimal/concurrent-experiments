// adapted from http://swannodette.github.io/2013/08/24/es6-generators-and-csp
function go_(machine, step) {
  while(!step.done) {
    var arr   = step.value(),
        state = arr[0],
        value = arr[1];

    switch (state) {
      case "park":
        setTimeout(function() { go_(machine, step); }, 0);
        return;
      case "continue":
        step = machine.next(value);
        break;
      case "sleep":
        setTimeout(function() { go_(machine, machine.next(value)); }, value);
        return;
    }
  }
}

function go(machine) {
  var gen = machine();
  go_(gen, gen.next());
}

function put(chan, val) {
  return function() {
    if(chan.length == 0) {
      chan.unshift(val);
      return ["continue", null];
    } else {
      return ["park", null];
    }
  };
}

function take(chan) {
  return function() {
    if(chan.length == 0) {
      return ["park", null];
    } else {
      var val = chan.pop();
      return ["continue", val];
    }
  };
}

function timeout(n) {
  return function() {
    return ["sleep", n];
  };
}

function concur() {
  var numch = [];
  var stringch = [];
  go(function* (){
    var a = yield take(numch);
    var b = yield take(numch);
    var c = yield take(numch);
    var d = a + b + c;
    yield put(stringch, a + " + " + b + " + " + c + " = " + d);
  });
  
  go(function* () {
    yield timeout(Math.floor(Math.random()*100));
    yield put(numch, 2 * 10);
  });
  	
  go(function* () {
    yield timeout(Math.floor(Math.random()*100));
    yield put(numch, 2 * 20)
    });
  go(function* () {
    yield timeout(Math.floor(Math.random()*100));
    yield put(numch, 30 + 40)
    });
 
  go(function* () {
    var res = yield take(stringch)
    console.log(res)
  });  
};

//concur();
