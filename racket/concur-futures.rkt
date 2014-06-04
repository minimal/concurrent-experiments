#lang racket
(require racket/future)
(let* ([x (future (lambda () (* 2 10)))]
       [y (future (lambda () (* 2 20)))]
       [z (future (lambda () (+ 30 40)))]
       [result (future (lambda () (format "~a + ~a + ~a = ~a"
                                          (touch x) (touch y) (touch z)
                                          (+ (touch x) (touch y) (touch z)))))])
  (printf (touch result)))
