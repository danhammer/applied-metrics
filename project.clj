(defproject applied-metrics "1.0.0-SNAPSHOT"
  :description "Applied econometrics and statistics in Clojure"
  :resources-path "resources"
  :repositories {"conjars" "http://conjars.org/repo/"}
  :dependencies [[org.clojure/clojure "1.3.0"]
                 [org.clojure/math.numeric-tower "0.0.1"]
                 [incanter/incanter-core "1.3.0-SNAPSHOT"]
                 [incanter/incanter-io "1.3.0-SNAPSHOT"]
                 [incanter/incanter-charts "1.3.0-SNAPSHOT"]
                 [clojure-csv/clojure-csv "2.0.0-alpha1"]
                 [lein-swank "1.4.4"]
                 [forma/forma "0.2.0-SNAPSHOT"]
                 [clj-http "0.4.1"]
                 [cheshire "4.0.0"]
                 [org.clojure/clojure-contrib "1.2.0"]]
  :profiles {:dev {:dependencies [[org.apache.hadoop/hadoop-core "0.20.2-dev"]
                                  [midje-cascalog "0.4.0"]
                                  [incanter/incanter-charts "1.3.0"]]
                   :plugins [[lein-swank "1.4.4"]
                             [lein-midje "2.0.0-SNAPSHOT"]]}})

