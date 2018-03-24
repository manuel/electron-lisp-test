webapp = {};

webapp.load = function() {
    var url = "ws://localhost:8080/ws";
    var ws = new WebSocket(url);
    var msg = { "text": "hi, this is a simple message.", "type": "default", "channel": "#foo", "id": 1 };
    ws.onopen = function(evt) {
        ws.send(JSON.stringify(msg));
    };
    ws.onmessage = function(evt) {
        alert("received: " + JSON.parse(evt.data).text);
    };
    ws.onclose = function(evt) {
        alert(evt);
    };
    ws.onerror = function(evt) {
        alert(evt);
    };
}
