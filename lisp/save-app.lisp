;; Save the current Lisp state to a standalone executable including the CCL kernel

(save-application "lisp/run" :toplevel-function 'main :prepend-kernel t)
