(defsystem "cas-demo-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Fr�d�ric FERRERE"
  :license ""
  :depends-on ("cas-demo"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cas-demo"))))
  :description "Test system for cas-demo"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
