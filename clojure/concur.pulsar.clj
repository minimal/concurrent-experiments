(ns concurpulsar.core
  (:use [co.paralleluniverse.pulsar core actors])
  (:refer-clojure :exclude [promise await]))

; uses actors, fibers, threads and promises from pulsar

(defsfn proc [res]
    (let [x (receive)
          y (receive)
          z (receive)
          r (+ x y z)]
          (deliver res
             (str x " + " y " + " z " = " r))))

(comment
    ; instead of promises could also use channels
    (let [c (channel)]
        (snd c "foo")
        (println (rcv c))))

(defn -main [& args]
    (let [res (promise)
          p (spawn proc res)]
        (spawn-fiber #(! p (* 2 10)))
        (spawn-thread #(! p (* 2 20)))
        (spawn-fiber #(! p (+ 30 40)))
        (println @res)))
