;; Load our Userfunctions
(load-package fuzzy.HardwareFunctions)
(load-package nrc.fuzzy.jess.FuzzyFunctions)

(import nrc.fuzzy.*)

;; get the vent Fuzzy Variable that describes the terms for vent positions
(defglobal ?*ventFVar* = (call fuzzy.Vent getVentChangeFuzzyVariable))

(defglobal ?*set-point* = 70)

;; Create a simulator
(defglobal ?*hw* = (init-simulator 15 ?*set-point*))

;; Tell Jess about the Java Bean classes
(defclass Thermometer fuzzy.Thermometer)
(defclass Vent fuzzy.Vent)
(defclass HeatPump fuzzy.HeatPump)

;; Create the Vent and Thermometer Beans
(bind ?n (n-floors))
(while (> ?n 0) do
       (definstance Thermometer (new fuzzy.Thermometer ?*hw* ?n))
       (definstance Vent (new fuzzy.Vent ?*hw* ?n))
       (bind ?n (- ?n 1)))

;; Create the HeatPump Beans
(bind ?n (n-heatpumps))
(while (> ?n 0) do
       (definstance HeatPump (new fuzzy.HeatPump ?*hw* ?n))
       (bind ?n (- ?n 1)))
       
;; Fuzzy Vent results
(deftemplate fuzzy-vent (slot floor) (slot fuzzy-change-state))

;; Deffunctions
(deffunction too-cold (?t)
  (return (< ?t (- ?*set-point* 2))))

(deffunction too-hot (?t)
  (return (> ?t (+ ?*set-point* 2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Heat pump rules

(defrule floor-too-cold-pump-off
  (HeatPump (state "off") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (reading ?t&:(too-cold ?t)))
  =>
  (set-hp-state ?p heating))

(defrule floors-hot-enough
  (HeatPump (state "heating") (number ?p))
  (not (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
                    (reading ?t&:(< ?t (+ ?*set-point* 0.25)))))
  =>
  (set-hp-state ?p off))

(defrule floor-too-hot-pump-off
  (HeatPump (state "off") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (reading ?t&:(too-hot ?t)))
  =>
  (set-hp-state ?p cooling))

(defrule floors-cool-enough
  (HeatPump (state "cooling") (number ?p))
  (not (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
                    (reading ?t&:(> ?t (- ?*set-point* 0.25)))))
  =>
  (set-hp-state ?p off))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rules to control the vents
  
;; Fuzzy rules to control the vents when cooling


(defrule cooling-and-temp-cold-rate-decreasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cold"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NB"))))
)

(defrule cooling-and-temp-cool-rate-decreasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cool"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NM"))))
)

(defrule cooling-and-temp-OK-rate-decreasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "OK"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NS"))))
)

(defrule cooling-and-temp-warm-rate-decreasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "warm"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "Z"))))
)

(defrule cooling-and-temp-hot-rate-decreasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "hot"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PS"))))
)



(defrule cooling-and-temp-cold-rate-zero
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cold"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NM"))))
)

(defrule cooling-and-temp-cool-rate-zero
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cool"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NS"))))
)

(defrule cooling-and-temp-OK-rate-zero
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "OK"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "Z"))))
)

(defrule cooling-and-temp-warm-rate-zero
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "warm"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PS"))))
)

(defrule cooling-and-temp-hot-rate-zero
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "hot"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PM"))))
)


(defrule cooling-and-temp-cold-rate-increasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cold"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NS"))))
)

(defrule cooling-and-temp-cool-rate-increasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cool"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "Z"))))
)

(defrule cooling-and-temp-OK-rate-increasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "OK"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PS"))))
)

(defrule cooling-and-temp-warm-rate-increasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "warm"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PM"))))
)

(defrule cooling-and-temp-hot-rate-increasing
  (HeatPump (state "cooling") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "hot"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PB"))))
)



;; Fuzzy rules to control the vents when heating

(defrule heating-and-temp-cold-rate-decreasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cold"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PB"))))
)

(defrule heating-and-temp-cool-rate-decreasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cool"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PM"))))
)

(defrule heating-and-temp-OK-rate-decreasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "OK"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PS"))))
)

(defrule heating-and-temp-warm-rate-decreasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "warm"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "Z"))))
)

(defrule heating-and-temp-hot-rate-decreasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "hot"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "decreasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NS"))))
)



(defrule heating-and-temp-cold-rate-zero
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cold"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PM"))))
)

(defrule heating-and-temp-cool-rate-zero
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cool"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PS"))))
)

(defrule heating-and-temp-OK-rate-zero
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "OK"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "Z"))))
)

(defrule heating-and-temp-warm-rate-zero
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "warm"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NS"))))
)

(defrule heating-and-temp-hot-rate-zero
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "hot"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "zero"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NM"))))
)


(defrule heating-and-temp-cold-rate-increasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cold"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "PS"))))
)

(defrule heating-and-temp-cool-rate-increasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "cool"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "Z"))))
)

(defrule heating-and-temp-OK-rate-increasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "OK"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NS"))))
)

(defrule heating-and-temp-warm-rate-increasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "warm"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NM"))))
)

(defrule heating-and-temp-hot-rate-increasing
  (HeatPump (state "heating") (number ?p))
  (Thermometer (floor ?f&:(eq ?p (which-pump ?f)))
               (fuzzyReading ?t&:(fuzzy-match ?t "hot"))
               (fuzzyReadingRateOfChange ?tr&:(fuzzy-match ?tr "increasing"))
  )
  =>
  (assert (fuzzy-vent (floor ?f) (fuzzy-change-state (new FuzzyValue ?*ventFVar* "NB"))))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Calculate by how much the vent should be adjusted when the 
;;; rules ahve all had a chance to contributre to the solution

(defrule perform-vent-change
  (declare (salience -100))
  ?fv <- (fuzzy-vent (floor ?f) (fuzzy-change-state ?fs))
 =>
  (bind ?vent-change-amount (?fs weightedAverageDefuzzify))
;;  (printout t "Floor " ?f ", vent open to " ?vent-state crlf)
  (change-vent-state ?f ?vent-change-amount)
  (retract ?fv)
)

;;(watch rules)
;;(watch activations)
;;(watch facts)
(run-until-halt)



