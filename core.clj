(ns concurrentexp.core
  (:gen-class)
  (:require [thornydev.go-lightly :as go]))

(defn do-with-promises []
  (let [promise-a (promise)
        promise-b (promise)
        promise-c (promise)]

    (future
      (println @promise-a " + " @promise-b " + " @promise-c " = "
               (+ @promise-a @promise-b @promise-c)))

    (future (deliver promise-a (* 2 10)))
    (future (deliver promise-b (* 2 20)))
    (future (deliver promise-c (+ 30 40)))))

(defn do-with-agents []
  (let [channelagent (agent [])]
    (println "with agent")
    (send channelagent conj (* 2 10))
    (send channelagent conj (* 2 20))
    (send channelagent conj (+ 30 40))
    (send channelagent
          (fn [[a b c]]
            (println a " + " b " + " c " = "
                     (+ a b c)))))
  nil)

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

(defn -main [arg]
  ;; work around dangerous default behaviour in Clojure
  (alter-var-root #'*read-eval* (constantly false))
  (case arg
    "1" (do-with-promises)
    "2" (do-with-agents)
    "3" (do-with-golightly)))
