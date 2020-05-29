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