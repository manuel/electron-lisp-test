var electron = require("electron");
var app = electron.app;
var dialog = electron.dialog;

app.on("ready", create_window);

function create_window() {
    dialog.showErrorBox("Hello", "World");
}
