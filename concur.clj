(let [chan (java.util.concurrent.LinkedBlockingQueue.)
      result (future (let [a (.take chan)
                           b (.take chan)
                           c (.take chan)]
                       (str a " + " b " + " c " = " (+ a b c))))]
  (future (.put chan (* 2 10)))
  (future (.put chan (* 2 20)))
  (future (.put chan (+ 30 40)))
  (println @result))
