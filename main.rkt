#lang racket

(require describe)

(require  web-server/http
          web-server/servlet-env
          web-server/servlet
          web-server/dispatch
          web-server/templates)


(require xml)
(require racket/runtime-path)

; (define (file->html f)
;   (λ (req)
;     (let  ([file (string-append "html_templates/" f ".html")])
;      (response/output
;        (λ (op)
;           (display   (include-template   (make-template  file)) op))))))


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



(define (error-handler request)
 (response/xexpr
  `(html
    (body
     (h1 "ERROR")))))


(define-values (dispatch generate-url)
 (dispatch-rules
   [("index") blog]
   [("") blog]
   [else not-found]))


(define (server)
   (serve/servlet
     (λ (req)
        (dispatch req))
     #:listen-ip "127.0.0.1"
     #:stateless? #t
     #:launch-browser? #f
     #:port 9001
     #:command-line? #t
     #:servlet-path "/"
     #:servlets-root "/"
     #:servlet-regexp   #rx"index|\\s*"))


#||#
(define skakata (server))
;(kill-thread skakata)
