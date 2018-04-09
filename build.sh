#!/usr/bin/env bash
set -eux

PLATFORM=$1

export APP_NAME="ElectronLisp"

# Build self-contained Lisp executable at lisp/run
if [ "$PLATFORM" == "macos" ]
then
    /Applications/LispWorks\ 7.1\ \(64-bit\)/LispWorks\ \(64-bit\).app/Contents/MacOS/lispworks-7-1-0-amd64-darwin -build lisp/save-app.lisp
else
    ../LispWorks/lispworks-7-1-0-amd64-linux -build lisp/save-app.lisp
fi
mv run-lw lisp/run

# Browserify
cd webapp
npm i
npm run-script webapp
cd ..

# Package
npm i
electron-packager --overwrite . $APP_NAME
