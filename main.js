// Main Electron application entry point

var electron = require("electron");
var app = electron.app;
var BrowserWindow = electron.BrowserWindow;
var dialog = electron.dialog;

var spawn = require("child_process").spawn;
var path = require("path");

var MAIN_URL = "http://localhost:8080";

// Wait for Electron readiness
app.on("ready", load);

app.on("quit", quit);
app.on("window-all-closed", quit);

// Keep reference to window to prevent it being GC'ed
var mainWindow = null;

var lispProcess = null;

function load() {
    // Spawn Lisp executable
    lispProcess = spawn(path.resolve(__dirname, "lisp/run"), [], { cwd: __dirname });
    // Create window
    setTimeout(function () {
            mainWindow = new BrowserWindow();
            mainWindow.loadURL(MAIN_URL);
        }, 500);
}

function quit() {
    if (lispProcess !== null) {
        lispProcess.kill("SIGKILL");
        lispProcess = null;
    }
}
