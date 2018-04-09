var EventEmitter = require("events");
var createReactClass = require("create-react-class");
var React = require("react");
var ReactDOM = require("react-dom");
var e = React.createElement;

var webapp = module.exports;

webapp.NEW_MESSAGE_EVT = "message";

webapp.ChannelStore = function ChannelStore(url) {
    this.emitter = new EventEmitter();
    this.messages = [];
    var emitter = this.emitter;
    var messages = this.messages;
    this.ws = new WebSocket(url);
    this.ws.onopen = function(evt) {
        console.log(evt);
    };
    this.ws.onmessage = function(evt) {
        console.log(evt);
        messages.push(JSON.parse(evt.data));
        emitter.emit(webapp.NEW_MESSAGE_EVT);
    };
    this.ws.onclose = function(evt) {
        console.log(evt);
    };
    this.ws.onerror = function(evt) {
        console.log(evt);
    };
};

webapp.ChannelComponent = createReactClass({
        getInitialState: function() {
            var that = this;
            var store = this.props.store;
            store.emitter.addListener(webapp.NEW_MESSAGE_EVT, function() {
                    that.setState({ messages: store.messages });
                });
            return { messages: store.messages };
        },
        render: function() {
            return e("ul", null,
                     this.props.store.messages.map(webapp.messageToComponent));
        }
    });

webapp.MessageComponent = createReactClass({
        render: function() {
            return e("li", null, this.props.msg.text);
        }
    });

webapp.messageToComponent = function(msg) {
    return React.createElement(webapp.MessageComponent, { msg: msg }, null);
}

webapp.load = function() {
    var url = "ws://localhost:8080/ws";
    var store = new webapp.ChannelStore(url);
    ReactDOM.render(React.createElement(webapp.ChannelComponent, { store: store }, null),
                    document.getElementById("content"));
    var elt = document.getElementById("input_text");
    elt.focus();
    document.getElementById("input_form").onsubmit = function() {
        var text = elt.value;
        store.ws.send(JSON.stringify({ text: text }));
        elt.value = "";
        return false;
    }
};
