// Main Electron application entry point

var electron = require("electron");
var app = electron.app;
var BrowserWindow = electron.BrowserWindow;

var spawn = require("child_process").spawn;
var path = require("path");

// Wait for Electron readiness
app.on("ready", load);

app.on("quit", quit);

// Keep reference to window to prevent it being GC'ed
var mainWindow = null;

var lispProcess = null;

function load() {
    // Spawn Lisp executable
    lispProcess = spawn(path.resolve(__dirname, "lisp/run"), []);
    setTimeout(function() {
            // Create window
            mainWindow = new BrowserWindow();
            mainWindow.loadURL("http://localhost:8080");
            mainWindow.openDevTools();
        },
        1000);
}

function quit() {
    if (lispProcess !== null) {
        lispProcess.kill("SIGKILL");
        lispProcess = null;
    }
}
