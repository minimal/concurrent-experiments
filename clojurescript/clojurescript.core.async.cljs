;; Live demo http://cljsfiddle.net/fiddle/minimal.concur
(defn concur []
  (let [numchan (chan)
        stringchan (chan)]
    (go
     (let [a (<! numchan)
           b (<! numchan)
           c (<! numchan)]
       (>! stringchan (str a " + " b " + " c " = " (+ a b c)))))
    (go (<! (timeout (rand-int 100))) (>! numchan (* 2 10)))
    (go (<! (timeout (rand-int 100))) (>! numchan (* 2 20)))
    (go (<! (timeout (rand-int 100))) (>! numchan (+ 30 40)))
 
    (go (println  (<! stringchan)))))
 
(concur)
