#!/usr/bin/env bash
set -eux

export APP_NAME="ElectronLisp"

# Build self-contained Lisp executable at lisp/run
ccl -l lisp/main.lisp -l lisp/save-app.lisp

# Package everything into macOS application bundle
rm -rf "$APP_NAME-darwin-x64"
electron-packager . $APP_NAME
