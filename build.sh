#!/usr/bin/env bash
set -eux

export APP_NAME="ElectronLisp"

# Build self-contained Lisp executable at lisp/run
/Applications/LispWorks\ 7.1\ \(64-bit\)/LispWorks\ \(64-bit\).app/Contents/MacOS/lispworks-7-1-0-amd64-darwin -build lisp/save-app.lisp
mv run-lw lisp/run

# Browserify
cd webapp
npm i
npm run-script webapp
cd ..

# Package everything into macOS application bundle
rm -rf "$APP_NAME-darwin-x64"
npm i
electron-packager . $APP_NAME
