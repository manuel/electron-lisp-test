;;;;; Main Lisp server entry point
(ql:quickload '(:websocket-driver-server :clack))

; Required, otherwise Clack will try to compile Hunchentoot at runtime
(clack.util:find-handler :hunchentoot)

(use-package :websocket-driver)

(defvar *echo-server*
  (lambda (env)
    (cond
     ((string= "/echo" (getf env :request-uri))
      (let ((ws (make-server env)))
        (on :message ws
            (lambda (message)
              (print message)
              (send ws message)))
        (lambda (responder)
          (declare (ignore responder))
          (start-connection ws))))
     (t
      '(200 (:content-type "text/html")
            (
             "<script>
alert('foo');
var url = 'ws://localhost:8080/echo';
var ws = new WebSocket(url);
var msg = 'hi, this is simple message.';
ws.onopen = function(evt) {
  console.log('send');
  ws.send(msg);
};
ws.onmessage = function(evt) {
  alert('received: ' + evt.data);
};
ws.onclose = function(evt) {
  alert(evt);
};
ws.onerror = function(evt) {
  alert(evt);
};
</script>
"))))))

(defun main ()
  (clack:clackup *echo-server* :server :hunchentoot :port 8080)
  ;; Prevent the app from exiting, there's probably a better way
  (read))

#|
(defclass channel ()
  ((messages :accessor messages-of)
   (message-count :accessor message-count-of)))

(defclass message ()
  ((text-content :accessor text-content-of)))
|#
