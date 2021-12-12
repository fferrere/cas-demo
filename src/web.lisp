(in-package :cl-user)
(defpackage cas-demo.web
  (:use :cl
        :caveman2
        :cas-demo.config
        :cas-demo.view
        :cas-demo.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :cas-demo.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))

(clear-routing-rules *web*)

(defun cas-client-config () (getf (config :cas) :client))

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute "/private" ()
  (multiple-value-bind (uid attrs) (cm:cas-authenticated-user *session*)
    (declare (ignore attrs))
    (render #P"private.html" (list :uid uid))))

(defroute "/logout" ()
  (let ((logout-url (quri:render-uri
                     (quri:make-uri
                      :scheme (lack.request:request-uri-scheme *request*)
                      :host (lack.request:request-server-name *request*)
                      :port (lack.request:request-server-port *request*)
                      :path "/"))))
    (cm:cas-logout (cas-client-config) *session* logout-url)))

(defun user-attributes ()
  (multiple-value-bind (uid attrs) (cm:cas-authenticated-user *session*)
    (declare (ignore uid))
    (render #P"details.html"
            (list :attributes
                  (mapcar
                   #'(lambda (elmt)
                       (cons (car elmt)
                             (let ((val (second elmt)))
                               (cond ((and val (typep val 'boolean)) "true")
                                     ((eq :AUTHENTICATION-DATE (car elmt))
                                      (local-time:format-timestring
                                       nil val :format '(:year "-" :month "-" :day " at " :hour "h" :min)))
                                     ((typep val 'null) "false")
                                     (t val)))))
                   attrs)))))

(defroute ("/ajax/show" :method :post) ()
  (user-attributes))

(defroute ("/ajax/hide" :method :get) ()
  "")

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
