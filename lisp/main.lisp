;;;;; Main Lisp server entry point

(ql:quickload :hunchentoot)

(defun main ()
  ;; Simply run a plain unconfigured Hunchentoot
  (hunchentoot:start (make-instance 'hunchentoot:acceptor :port 8000))
  ;; Prevent the app from exiting, there's probably a better way
  (read))
