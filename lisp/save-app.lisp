;; Save the current Lisp state to a standalone executable

#+ccl
(save-application "lisp/run" :toplevel-function 'main :prepend-kernel t)

#+lispworks
(progn
  (load-all-patches)
  (setf system:*stack-overflow-behaviour* :warn)
  (load "./lib/asdf.lisp")
  (provide "asdf")
  #-quicklisp
  (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
      (load quicklisp-init)))
  (load "./lisp/main.lisp")
  (deliver 'main "run-lw" 0 :interface :capi :keep-pretty-printer t))
