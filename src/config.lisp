(in-package :cl-user)
(defpackage cas-demo.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*
           :appenv
           :developmentp
           :productionp))
(in-package :cas-demo.config)

(setf (config-env-var) "APP_ENV")

(defparameter *application-root*   (asdf:system-source-directory :cas-demo))
(defparameter *static-directory*   (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defconfig :common
    `(:databases ((:maindb :sqlite3 :database-name ":memory:"))))

(defconfig |development|
    '(:cas (:cas-server-url "https://casserver.herokuapp.com/cas"
	    :app-url "http://localhost:5000/"
	    :app-logout-url "http://localhost:5000/"
	    :app-excludes ("/" "/logout"))))

(defconfig |production|
    `(:cas (:cas-server-url ,(uiop:getenv "CAS_URL")
	    :app-url ,(uiop:getenv "APP_URL")
	    :app-logout-url ,(uiop:getenv "APP_LOGOUT_URL")
	    :app-excludes ,(uiop:split-string (uiop:getenv "APP_EXCLUDES")))))

(defconfig |test|
  '())

(defun config (&optional key)
  (envy:config #.(package-name *package*) key))

(defun appenv ()
  (uiop:getenv (config-env-var #.(package-name *package*))))

(defun developmentp ()
  (string= (appenv) "development"))

(defun productionp ()
  (string= (appenv) "production"))

