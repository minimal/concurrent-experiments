#lang racket
(let ([numbers (make-channel)]
      [result (make-channel)])
  (thread (lambda () (let ([x (channel-get numbers)]
                           [y (channel-get numbers)]
                           [z (channel-get numbers)])
                       (channel-put result (format "~a + ~a + ~a = ~a" x y z (+ x y z))))))
  (thread (lambda () (channel-put numbers (* 2 10))))
  (thread (lambda () (channel-put numbers (* 2 20))))
  (thread (lambda () (channel-put numbers (+ 30 40))))
  (printf (channel-get result)))
