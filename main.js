// Main Electron application entry point

var electron = require("electron");
var app = electron.app;
var BrowserWindow = electron.BrowserWindow;

var spawn = require("child_process").spawn;
var path = require("path");

// Wait for Electron readiness
app.on("ready", load);

// Keep reference to window to prevent it being GC'ed
var mainWindow = null;

function load() {
    // Spawn Lisp executable
    spawn(path.resolve(__dirname, "lisp/run"), []);
    // Create window
    mainWindow = new BrowserWindow();
    mainWindow.loadURL("http://localhost:8000");
}
