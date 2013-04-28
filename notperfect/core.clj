(ns concurrentexp.core
  (:gen-class)
  (:require [thornydev.go-lightly :as go]))

(defn do-with-promises []
  (let [a (promise)
        b (promise)
        c (promise)]

    (future (println @a " + " @b " + " @c " = " (+ @a @b @c)))
    (future (deliver a (* 2 10)))
    (future (deliver b (* 2 20)))
    (future (deliver c (+ 30 40)))))

(defn do-with-agents []
  (let [channelagent (agent [])]
    (send channelagent conj (* 2 10))
    (send channelagent conj (* 2 20))
    (send channelagent conj (+ 30 40))
    (send channelagent
          (fn [[a b c]]
            (println a " + " b " + " c " = "
                     (+ a b c))))))

(defn do-with-golightly []
  (let [numchan (go/channel)
        strchan (go/channel)]
    (go/go
     (let [a (go/take numchan)
           b (go/take numchan)
           c (go/take numchan)]
       (go/put strchan (str a " + " b " + " c " = " (+ a b c)))))

    (go/go (go/put numchan (* 2 10)))
    (go/go (go/put numchan (* 2 20)))
    (go/go (go/put numchan (+ 30 40)))
    (println (go/take strchan))))

(defn do-with-futures []
  (let [a (future (* 2 10))
        b (future (* 2 20))
        c (future (+ 30 40))]
    (future
      (println @a " + " @b " + " @c " = " (+ @a @b @c)))))

(defmacro fut-to-queue [q body] `(future (.put ~q ~body)))
(defn do-with-future-queue []
  (let [chan (java.util.concurrent.LinkedBlockingQueue.)
        result (future
                 (let [a (.take chan)
                       b (.take chan)
                       c (.take chan)]
                   (str a " + " b " + " c " = " (+ a b c))))]
    (fut-to-queue chan (* 2 10))
    (fut-to-queue chan (* 2 20))
    (fut-to-queue chan (+ 30 40))
    (println @result)))

(defn -main [arg]
  (alter-var-root #'*read-eval* (constantly false))
  (case arg
    "1" (do-with-promises)
    "2" (do-with-agents)
    "3" (do-with-golightly)
    "4" (do-with-futures)
    "5" (do-with-future-queue))
  nil)
