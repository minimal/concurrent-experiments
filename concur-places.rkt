#lang racket
(provide main)
(define (main)
  (define p (place ch
              (define in (place-channel-get ch))
              (define-values (x y z) (apply values (build-list 3 (lambda (i) (place-channel-get in)))))
              (place-channel-put ch (format "~a + ~a + ~a = ~a" x y z (+ x y z)))))
  (define-values (numbers-put numbers-get) (place-channel))
  (place-channel-put p numbers-get)
  (map (lambda (pl) (place-channel-put pl numbers-put)) (list
      (place ch (define out (place-channel-get ch)) (place-channel-put out (* 2 10)))
      (place ch (define out (place-channel-get ch)) (place-channel-put out (* 2 20)))
      (place ch (define out (place-channel-get ch)) (place-channel-put out (+ 30 40)))))
  (printf (place-channel-get p)) (newline))
