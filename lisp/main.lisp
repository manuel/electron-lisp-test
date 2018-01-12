(ql:quickload :hunchentoot)

(defun main ()
  (hunchentoot:start (make-instance 'hunchentoot:acceptor :port 8000))
  ;; Prevent the app from exiting, there's probably a better way
  (read))

