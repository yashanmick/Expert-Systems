/*

(deftemplate automobile3
	"A specific car."
	(slot make)
	(slot model)
	(slot year (type INTEGER))
	(slot color (default white)))

;;unordered facts
(reset)
(assert (automobile2 (model LeBaron) (make Chryslar) (year 1997)))

;;(retract 1)
	;;inorder to delete a fact by fact id

*/

/*
;;multislot
(deftemplate box (slot location) (multislot contents))

(bind ?id (assert (box (location kitchen)
						(contents spatula sponge frying-pan))))

(modify ?id (location dining-room))

*/

/*
;;--------------------------!extends---------------------------------
(deftemplate automobile
	"A specific car."
	(slot make)
	(slot model)
	(slot year (type INTEGER))
	(slot color (default white)))

(deftemplate used-auto extends automobile
	(slot mileage)
	(slot blue-book-value)
	(multislot owners))

(assert (used-auto (model LeBaron)
					(make Chryslar) 
					(year 1997) 
					(mileage 5000km) 
					(blue-book-value 75) 
					(owners Jacob Freidman)))
*/




/*
;;------------------------!facts----------------------------
(deffacts my-facts "Some useless facts"
	(foo bar)
	(bar foo))
*/

;;------------------------!ordered facts----------------------------

(deftemplate father-of
	"A directed association between a father and a child."
	(declare (ordered TRUE)))

(assert (father-of danielle ejfried))
(assert (father-of christoff gandolf))
(assert (shopping-list egg milk bread))



