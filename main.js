var electron = require("electron");
var app = electron.app;
var BrowserWindow = electron.BrowserWindow;

var spawn = require("child_process").spawn;
var path = require("path");

app.on("ready", load);

var mainWindow = null;

function load() {
    spawn(path.resolve(__dirname, "lisp/run"), []);
    mainWindow = new BrowserWindow();
    mainWindow.loadURL("http://localhost:8000");
}
