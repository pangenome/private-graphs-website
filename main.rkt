#lang racket

(require describe)

(require  web-server/http
          web-server/servlet-env
          web-server/servlet
          web-server/dispatch
          web-server/templates)


(require xml)
(require racket/runtime-path)


(define (index  request)
  (response/xexpr
    `(html
       (head (title "My Blog"))
       (body (h1 "Under construction")))))


(define (not-found request)
 (response/xexpr
  `(html
    (body
     (h1 "NOT FOUND")))))



(define (error-handler request)
 (response/xexpr
  `(html
    (body
     (h1 "ERROR")))))


(define-values (dispatch generate-url)
 (dispatch-rules
   [("index") index]
   [("") index]
   [else not-found]))

; [else (error "There is no procedure to handle the url.")]))
    
(define running-server
 (serve/servlet   (λ (req) (dispatch req))
   #:listen-ip "127.0.0.1"
   #:stateless? #t
   #:launch-browser? #f
   #:port 9001
   #:command-line? #t
   #:servlet-path "/"
   #:servlets-root "/"
   #:servlet-regexp   #rx"index|\\s*"))


;(running-server)
; (define hello (lambda () '()))
;
; (set! hello
;    (lambda (req)
;     (response/output
;       (lambda (out)
;         (displayln "Hello, world fdfds " out)))))
;
;
; (define the-thread '())
;
; (define request-handler
;    (lambda (req)
;      (set! the-thread (current-thread))
;      (hello req)))



; (define SEQ (string->bytes/utf-8 "sequence"))


    ; (with-handlers ([exn:break? (lambda (e) (displayln "pipa"))])
    ;   (sync/enable-break never-evt)))))
    ;

