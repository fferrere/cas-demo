# CAS-DEMO

Common Lisp Demo Web App with [Caveman](https://github.com/fukamachi/caveman) framework, and [CAS (V2)](https://apereo.github.io/cas/6.0.x/protocol/CAS-Protocol.html) authentification.

Other libraries :
- [htmx](https://htmx.org/) : Ajax, CSS and more
- [cas-middleware](https://github.com/fferrere/cas-middleware) : Caveman Middleware Package for CAS authentication
- [cl-cas](https://github.com/fferrere/cl-cas) : Common Lisp CAS client 

Use CAS server (Demo) from Apereo https://casserver.herokuapp.com/cas/login

## Usage
- From Emacs REPL
  - (ql:quickload "cas-demo")
  - (cas-demo:start)
- Open browser to : http://localhost:5000
- Demo CAS User
  - Login : casuser
  - Password : Mellon

Welcome page is public, so no authentication is required


## Installation
- git clone https://github.com/fferrere/cl-cas
- git clone https://github.com/fferrere/cas-middleware
- git clone https://github.com/fferrere/cas-demo

## Author

* Frédéric FERRERE (frederic.ferrere@gmail.com)

## Licence

Apache-2.0 (https://www.apache.org/licenses/LICENSE-2.0)

