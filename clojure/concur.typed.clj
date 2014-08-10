(ns clojuretyped-exp.concur
  (:require
   [clojure.core.async :as async :refer [<! >! <!! timeout alt!]]
   [clojure.core.typed.async :as tasync :refer [go chan]]
   [clojure.core.typed :refer [ann check-ns ann-form AnyInteger cf] :as t]))


(t/defn concur [] :- Any
  (let [numchan (chan :- AnyInteger)
        stringchan (chan :- String)]
    (go
      (let [a (or (<! numchan) 0)
            b (or (<! numchan) 0)
            c (or (<! numchan) 0)]
        (>! stringchan (str a " + " b " + " c " = " (+ a b c)))))
    (go (<! (timeout (rand-int 100))) (>! numchan (* 2 10)))
    (go (<! (timeout (rand-int 100))) (>! numchan (* 2 20)))
    (go (<! (timeout (rand-int 100))) (>! numchan (+ 30 40)))

    (go (println  (<! stringchan)))))

(concur)
