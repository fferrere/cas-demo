(ql:quickload :cas-demo)

(defpackage cas-demo.app
  (:use :cl)
  (:import-from :lack.builder
                :builder)
  (:import-from :ppcre
                :scan
                :regex-replace)
  (:import-from :cas-demo.web
                :*web*)
  (:import-from :cas-demo.config
                :config
                :productionp
                :*static-directory*))
(in-package :cas-demo.app)

(builder
 (:static
  :path (lambda (path)
          (if (ppcre:scan "^(?:/images/|/css/|/js/|/robot\\.txt$|/favicon\\.ico$)" path)
              path
              nil))
  :root *static-directory*)
 (if (productionp)
     nil
     :accesslog)
 (if (getf (config) :error-log)
     `(:backtrace
       :output ,(getf (config) :error-log))
     nil)
 :session
 (if (productionp)
     nil
     (lambda (app)
       (lambda (env)
         (let ((datafly:*trace-sql* t))
           (funcall app env)))))
 (:auth-cas :config (getf (config :cas) :client)
            :excludes (getf (config :cas) :excludes))
 *web*)
