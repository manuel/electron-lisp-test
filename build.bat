"C:\Program Files\LispWorks\lispworks-7-1-0-x64-windows.exe" -build lisp/save-app.lisp
move run-lw.exe lisp\run.exe
electron-packager --overwrite . ElectronLispWin
