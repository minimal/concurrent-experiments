async = require( "async" );

async.parallel([
    function(cb){
        cb(null, 2 * 10);
    },
    function(cb){
        cb(null, 2 * 20);
    },
    function(cb){
        cb(null, 30 + 40);
    }
],
function(err, results){
    var answer = 0;
    var result = "";
    for( var i in results ){
        result += results[i]+"+";
        answer += results[i];
    }
    result = result.substring(0, result.length-1);
    console.log( result + " = " + answer );
});
