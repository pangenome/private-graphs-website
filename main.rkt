#lang racket

(require describe)
             
(require racket/runtime-path)
(require xml)



(require

  net/url
  (prefix-in files: web-server/dispatchers/dispatch-files)
  (prefix-in filter: web-server/dispatchers/dispatch-filter)
  (prefix-in sequencer: web-server/dispatchers/dispatch-sequencer)
  web-server/dispatchers/filesystem-map
  web-server/servlet-dispatch
  web-server/web-server
  web-server/http
  web-server/servlet-env
  web-server/configuration/responders
  web-server/servlet
  web-server/dispatch
  web-server/templates)

(define url->path/static (make-url->path "static"))

(define static-dispatcher
  (files:make #:url->path
              (λ (u)
                (url->path/static
                 (struct-copy url u [path (cdr (url-path u))])))))

(define (index  request)
  (response/output
   (λ (op) (display  (include-template "html_templates/index.html") op))))

(define (blog request)
  (response/output
   (λ (op) (display  (include-template "html_templates/blog.html") op))))


(define (not-found request)
 (response/xexpr
  `(html
    (body
     (h1 "NOT FOUND")))))


(define-values (backend  generate-url)
 (dispatch-rules
   [("index") blog]
   [("") blog]
   [else not-found]))


(define (run-server)
    (serve
      #:listen-ip "127.0.0.1"
      #:port 3003
      #:dispatch (sequencer:make
                  (filter:make #rx"^/static/" static-dispatcher)
                  (dispatch/servlet backend)
                  (dispatch/servlet not-found))))



(define server (run-server))

