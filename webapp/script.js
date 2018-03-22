webapp = {};

webapp.load = function() {
    var url = 'ws://localhost:8080/ws';
    var ws = new WebSocket(url);
    var msg = 'hi, this is simple message.';
    ws.onopen = function(evt) {
        console.log('send');
        ws.send(msg);
    };
    ws.onmessage = function(evt) {
        alert('received: ' + evt.data);
    };
    ws.onclose = function(evt) {
        alert(evt);
    };
    ws.onerror = function(evt) {
        alert(evt);
    };
}