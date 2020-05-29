;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Templates

(deftemplate product
  (slot name)
  (slot category)
  (slot part-number)
  (slot price)
  (multislot requires))

(deftemplate customer
  (slot customer-id)
  (multislot name)
  (multislot address))

(deftemplate order
  (slot customer-id)
  (slot order-number))

(deftemplate line-item
  (slot order-number)
  (slot customer-id)
  (slot part-number)
  (slot quantity (default 1)))

(deftemplate recommend
  (slot order-number)
  (multislot because)
  (slot type)
  (slot part-number))

(deftemplate next-order-number
  (slot value))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Rules for creating new recommendations

(defrule recommend-requirements
  "If customer is buying a product that requires another product,
   recommend the most expensive instance of the second category of product."

  ;; ?currentOrder is the most recent order from a given customer
  (order (customer-id ?id) (order-number ?currentOrder))
  (not (order (customer-id ?id) (order-number ?order2&:(> ?order2 ?currentOrder))))

  ;; They're ordering a product which requires an item from ?category,
  (line-item (order-number ?currentOrder) (part-number ?part))
  (product (part-number ?part) (name ?product)
           (requires $? ?category $?))

  ;; There's another part in ?category
  (product (category ?category) (price ?price) (part-number
                                                ?second-part))

  ;; And it's the most expensive one
  (not (product (category ?category) (price ?p&:(> ?p ?price))))

  =>

  ;; Recommend it!
  (assert (recommend (order-number ?currentOrder)
                     (type requirement)
                     (part-number ?second-part)                     
                     (because ?product))))

(defrule recommend-more-media
  "If customer buys a disk or tape, recommend a random other item of
the same category."
  ;; There are two recordings of the same type
  ?p1 <- (product (part-number ?part1) (category ?c&dvd-disk|videotape) (name ?name))
  ?p2 <- (product (part-number ?part2) (category ?c))
  (test (neq ?p1 ?p2))

  ;; And the customer is buying one of them
  (line-item (order-number ?order) (part-number ?part1))

  ;; And we haven't recommended any media of this type yet
  (not (recommend (order-number ?order)
                  (type =(sym-cat discretionary- ?c))))
  =>

  ;; Recommend the other one
  (assert (recommend (order-number ?order)
                     (because ?name)
                     (part-number ?part2)
                     (type =(sym-cat discretionary- ?c)))))

(defrule recommend-same-type-of-media
  "If customer has bought a disk or tape in the past, recommend a
random other item of the same category."
  ;; There are two recordings of the same type
  ?p1 <- (product (part-number ?part1) (category ?c&dvd-disk|videotape) (name ?name))
  ?p2 <- (product (part-number ?part2) (category ?c))
  (test (neq ?p1 ?p2))

  ;; This customer has bought one of them in a past order
  (line-item (customer-id ?id) (order-number ?order1) (part-number ?part1))
  (order (customer-id ?id) (order-number ?currentOrder&:(> ?currentOrder ?order1)))
  (not (order (customer-id ?id) (order-number ?order3&:(> ?order3 ?currentOrder))))

  ;; But not the other
  (not (line-item (customer-id ?id) (part-number ?part2)))
  
  ;; and we haven't recommended any media of this type yet
  (not (recommend (order-number ?currentOrder)
                  (type =(sym-cat discretionary- ?c))))
  =>

  ;; Recommend the other one.
  (assert (recommend (order-number ?currentOrder)
                     (because ?name)
                     (part-number ?part2)
                     (type =(sym-cat discretionary- ?c)))))

(defrule recommend-media-for-player
  "If customer has bought a VCR or DVD player in the past, recommend
some media for it."
  ;; There are is recording
  ?p1 <- (product (part-number ?media) (category ?c&dvd-disk|videotape))

  ;; This customer has bought a player for it in the past
  (product (name ?name) (part-number ?player)
           (category =(if (eq ?c dvd-disk) then dvd else vcr)))
  (line-item (customer-id ?id) (order-number ?order1) (part-number ?player))
             
  ;; And now they're placing a new order
  (order (customer-id ?id) (order-number ?currentOrder&:(> ?currentOrder ?order1)))
  (not (order (customer-id ?id) (order-number ?order3&:(> ?order3 ?currentOrder))))

  ;; But they've never bought this recording
  (not (line-item (customer-id ?id) (part-number ?media)))
  
  ;; and we haven't recommended any media of this type yet
  (not (recommend (order-number ?currentOrder)
                  (type =(sym-cat discretionary- ?c))))
  =>

  ;; Recommend the recording
  (assert (recommend (order-number ?currentOrder)
                     (because ?name)
                     (part-number ?media)
                     (type =(sym-cat discretionary- ?c)))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rules for modifying existing recommendations

(defrule coalesce-recommendations
  "If there are multiple recommendations for the same part,
   coalesce them."
  ?r1 <- (recommend (order-number ?order) (type ?type)
                    (because ?product) (part-number ?part))
  ?r2 <- (recommend (order-number ?order) (part-number ?part) 
                    (because $?products&:(not (member$ ?product
                                                   $?products))))
  =>
  (retract ?r1 ?r2)
  (assert (recommend (order-number ?order) (type ?type)
                     (because (create$ ?product $?products))
                     (part-number ?part))))
 
(defrule remove-satisfied-recommendations
  "If there are two products in the same category, and one is part of
an order, and there is a recommendation of type 'requirement' for
the other part, then remove the recommendation, as the customer is
already buying something in that category."
  (product (part-number ?part1) (category ?category))
  (product (part-number ?part2) (category ?category))
  (line-item (order-number ?order) (part-number ?part2))
  ?r <- (recommend (order-number ?order)
                   (part-number ?part1) (type requirement))
  =>
  (retract ?r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Queries

(defquery all-products
  (product))

(defquery recommendations-for-order
  (declare (variables ?order))
  (recommend (order-number ?order) (part-number ?part))
  (product (part-number ?part)))

(defquery items-for-order
  (declare (variables ?order))
  (line-item (order-number ?order) (part-number ?part))
  (product (part-number ?part)))

(defquery order-number
  (next-order-number))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Track order numbers

(deffunction get-new-order-number ()
  (bind ?it (run-query order-number))
  (if (not (?it hasNext)) then
    (assert (next-order-number (value 1002)))
    (return 1001)
    else
    (bind ?token (?it next))
    (bind ?fact (?token fact 1))
    (bind ?number (?fact getSlotValue value))
    (modify ?fact (value (+ ?number 1)))
    (return ?number)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Catalog

(deffacts product-catalog

  (product (name "TekMart VC-103 VCR") (category vcr)
           (part-number TMVC103) (price 125)
           (requires video-cables tv batteries videotape))
  (product (name "TekMart DVD-223 DVD Player") (category dvd)
           (part-number TMDVD223) (price 225)
           (requires video-cables tv batteries dvd-disk))
  (product (name "TekMart TV-19 19'' TV") (category tv)
           (part-number TMTV19) (price 229)
           (requires batteries))
  (product (name "TekMart TV-24 24'' TV") (category tv)
           (part-number TMTV24) (price 299)
           (requires batteries))
  (product (name "Eraserhead VHS") (category videotape)
           (part-number EHVHS) (price 25.99)
           (requires vcr))
  (product (name "Casablanca VHS") (category videotape)
           (part-number CBVHS) (price 12.99)
           (requires vcr))
  (product (name "Repo Man VHS") (category videotape)
           (part-number RMVHS) (price 19.99)
           (requires vcr))
  (product (name "Dumbo DVD") (category dvd-disk)
           (part-number DDVD) (price 19.99)
           (requires dvd))
  (product (name "The Matrix DVD") (category dvd-disk)
           (part-number MDVD) (price 29.99)
           (requires dvd))
  (product (name "TekMart CB-32 Video Cables") (category video-cables)
           (part-number TMCB32) (price 24.99))
  (product (name "Bose Gold Standard Video Cables") (category video-cables)
           (part-number BGSVC) (price 54.99))
  (product (name "4-pack Duracell AA Batteries") (category batteries)
           (part-number DBAA4PK) (price 3.99))
  (product (name "10-pack TekMart AA Batteries") (category batteries)
           (part-number TMAA10PK) (price 1.99)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cleanup rules for doing partial resets

(defmodule CLEANUP)

(defrule CLEANUP::initialize-order-1
  (declare (auto-focus TRUE))
  (MAIN::initialize-order ?number)
  ?item <- (line-item (order-number ?number))
  =>
  (retract ?item))

(defrule CLEANUP::initialize-order-2
  (declare (auto-focus TRUE))
  (MAIN::initialize-order ?number)
  ?rec <- (recommend (order-number ?number))
  =>
  (retract ?rec))

(defrule CLEANUP::initialize-order-3
  (declare (auto-focus TRUE))
  ?init <- (MAIN::initialize-order ?number)
  (not (line-item (order-number ?number)))
  (not (recommend (order-number ?number)))
  =>
  (retract ?init))

(defrule CLEANUP::clean-up-order
  (declare (auto-focus TRUE))
  ?clean <- (MAIN::clean-up-order ?number)
  ?order <- (order (order-number ?number))
  =>
  (assert (initialize-order ?number))
  (retract ?clean ?order))

(set-current-module MAIN)

