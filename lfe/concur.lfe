(defmodule concur
  (export all))

(defun do-receive (pid)
  (receive
    (a
      (receive
        (b
         (receive
           (c
            (! pid (io:format "~p + ~p + ~p = ~p~n" (list a b c (+ a b c)))))))))))

(defun do-concur ()
  (let* ((pid (self))
         (receiver (spawn (lambda () (do-receive pid)))))
    (spawn (lambda () (! receiver (* 2 10))))
    (spawn (lambda () (! receiver (* 2 20))))
    (spawn (lambda () (! receiver (+ 30 40))))
    (receive
      (result
       (io:format "~s~n" (list result))))))
