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
            (lambda (msg)
              (let ((msg-obj (yason:parse msg)))
                (send ws (gethash "text" msg-obj)))))
        (lambda (responder)
          (declare (ignore responder))
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

#|
(defclass channel ()
  ((messages :accessor messages-of)
   (message-count :accessor message-count-of)))

(defclass message ()
  ((text-content :accessor text-content-of)))
|#
