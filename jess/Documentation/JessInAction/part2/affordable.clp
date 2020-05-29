;
; Defquery demo from chapter 7 of "Jess in Action"
;

(deftemplate gift (slot name) (slot price))

(defquery find-affordable-gifts 
    "Finds all gifts in a given price range" 
    (declare (variables ?lower ?upper)) 
    (gift (price ?p&:(and (> ?p ?lower) (< ?p ?upper)))))

(deffacts catalog 
     (gift (name red-scarf) (price 20)) 
     (gift (name leather-gloves) (price 35)) 
     (gift (name angora-sweater) (price 250)) 
     (gift (name mohair-sweater) (price 99)) 
     (gift (name keychain) (price 5)) 
     (gift (name socks) (price 6)) 
     (gift (name leather-briefcase) (price 300)))

(reset)

(bind ?it (run-query find-affordable-gifts 20 100))

(printout t "These gifts are priced between 20 and 100 dollars:" crlf)
(while (?it hasNext) 
    (bind ?token (call ?it next)) 
    (bind ?fact (call ?token fact 1)) 
    (bind ?name (fact-slot-value ?fact name)) 
    (printout t ?name crlf))

