// Main Electron application entry point

var electron = require("electron");
var app = electron.app;
var BrowserWindow = electron.BrowserWindow;
var dialog = electron.dialog;

var ab2str = require("arraybuffer-to-string")
var async = require("async");

var http = require("http");
var spawn = require("child_process").spawn;
var path = require("path");

var MAIN_URL = "http://localhost:8080";

// Wait for Electron readiness
app.on("ready", load);

app.on("quit", quit);

// Keep reference to window to prevent it being GC'ed
var mainWindow = null;

var lispProcess = null;

function load() {
    // Spawn Lisp executable
    lispProcess = spawn(path.resolve(__dirname, "lisp/run"), [], { cwd: __dirname });
    lispProcess.stdout.on("data", function(data) {
            dialog.showErrorBox("Lisp stdout:", ab2str(data));
        });
    lispProcess.stderr.on("data", function(data) {
            dialog.showErrorBox("Lisp stderr: ", ab2str(data));
        });

    // Create window
    setTimeout(function () {
            mainWindow = new BrowserWindow();
            mainWindow.loadURL(MAIN_URL);
            mainWindow.openDevTools();
        }, 500);
    /*
    waitForLispAndThenCall(function() {
            // Create window
            mainWindow = new BrowserWindow();
            mainWindow.loadURL(MAIN_URL);
            mainWindow.openDevTools();
        });
    */
}
/*
function waitForLispAndThenCall(fn) {
    async.retry({ times: 5, interval: 200 },
                function(cb) {
                    http.request(MAIN_URL, cb);
                },
                function(err) {
                    if (err) {
                        dialog.showErrorBox("Error", "Lisp didn't start: " + err);
                    } else {
                        fn();
                    }
                });
}
*/
function quit() {
    if (lispProcess !== null) {
        lispProcess.kill("SIGKILL");
        lispProcess = null;
    }
}
