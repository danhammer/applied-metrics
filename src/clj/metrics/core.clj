(ns metrics.core
  (:use [incanter.core]
        [incanter.stats :only (sample-normal)]))

(defn create-data [n]
  (let [ones (repeat n 1)
        x (sample-normal n)
        y (map + (map * 2 x) (sample-normal n :sd 0.5))]
    [y (bind-columns ones x)]))

