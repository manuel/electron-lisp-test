;;;;; Main Lisp server entry point
(ql:quickload '(:websocket-driver-server :clack :yason))

(defconstant +server+ :hunchentoot)

; Required, otherwise Clack will try to compile Hunchentoot at runtime
(clack.util:find-handler +server+)

(use-package :websocket-driver)

(defvar *echo-server*
  (lambda (env)
    (cond
     ((string= "/ws" (getf env :request-uri))
      (let ((ws (make-server env)))
        (on :message ws
            (lambda (json)
              (let ((message (json-to-message json)))
                (send ws (message-to-json message)))))
        (lambda (responder)
          (declare (ignore responder))
          (send ws (message-to-json (make-message :text "Hello world from Lisp!")))
          (start-connection ws))))
     ((string= "/script.js" (getf env :request-uri))
      `(200 (:content-type "text/javascript")
            (,(file-to-string (merge-pathnames "webapp/script.js" (lw:current-pathname))))))
     (t
      `(200 (:content-type "text/html")
            (,(file-to-string (merge-pathnames "webapp/index.html" (lw:current-pathname)))))))))

(defun file-to-string (filename)
  (with-open-file (stream filename)
    (let ((contents (make-string (file-length stream))))
      (read-sequence contents stream)
      contents)))

(defun main ()
  (clack:clackup *echo-server* :server +server+ :port 8080)
  ;; Prevent the app from exiting, there's probably a better way
  (read))

(defclass message ()
  ((text :accessor message-text :initarg :text)))

(defun make-message (&rest args)
  (apply #'make-instance 'message args))

(defun json-to-message (json)
  (let ((ht (yason:parse json)))
    (make-instance 'message
                   :text (gethash "text" ht))))

(defun message-to-json (message)
  (let ((ht (make-hash-table :test #'equal)))
    (setf (gethash "text" ht) (message-text message))
    (with-output-to-string (*standard-output*)
      (yason:encode ht))))
