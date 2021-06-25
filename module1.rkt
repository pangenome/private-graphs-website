#lang racket

(require describe)
             
(require
  racket/runtime-path
  xml
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



(define ext=>mime-type
  #hash((#""     . #"text/html; charset=utf-8")
        (#"html" . #"text/html; charset=utf-8")
        (#"png"  . #"image/png")
        (#"rkt"  . #"text/x-racket; charset=utf-8")))


; (rest '(#""     . '()))
 
; a handler for static files:
(define (handle-file-request req)
  ; extract the URI from the request:
  (define uri (request-uri req))
  ; extract the resource from the URI:
  (define resource 
    (map path/param-path (url-path uri)))
  ; find the file location:
  (define file (string-append
                document-root
                "/" 
                (string-join resource "/")))
  (cond
    [(file-exists? file)
     ; =>
     ; find the MIME type:
     (define extension (filename-extension file))
     (define mime-type
       (hash-ref ext=>mime-type extension 
                 (λ () TEXT/HTML-MIME-TYPE)))
     ; read the file contents:
     (define data (file->bytes file))
     ; construct the response:
     (response
      200 #"OK"
      (current-seconds)
      mime-type
      '()
      (λ (client-out)
        (write-bytes data client-out)))]
    ; send an error page otherwise:
    [else
     ; =>
     (response/xexpr
      #:code     404
      #:message  #"Not found"
      `(html
        (body
         (p "Not found"))))]))
