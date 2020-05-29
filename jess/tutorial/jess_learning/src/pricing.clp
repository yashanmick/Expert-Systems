;; First define templates for the model classes so we can use them
;; in our pricing rules. This doesn't create any model objects --
;; it just tells Jess to examine the classes and set up templates
;; using their properties

;;(import gov.sandia.jess.example.pricing.model.*)
;;(deftemplate Order       (declare (from-class Order)))
;;(deftemplate OrderItem   (declare (from-class OrderItem)))
;;(deftemplate CatalogItem (declare (from-class CatalogItem)))
;;(deftemplate Customer    (declare (from-class Customer)))

(deftemplate Alumno
    (slot number)
    (slot nota)
    (slot condition)
)



;; Now define the pricing rules themselves. Each rule matches a set
;; of conditions and then creates an Offer object to represent a
;; bonus of some kind given to a customer. The rules assume that
;; there will be just one Order, its OrderItems, and its Customer in 
;; working memory, along with all the CatalogItems.

(defrule Aprobados
    ?f1 <- (Alumno (number ?number)(nota ?nota)(condition nil))
    =>
    	(if(> ?nota 10.5) then
    		(retract ?f1)
    			(assert (Alumno(number ?number)(nota ?nota)(condition aprobado)))
    	else
    		(retract ?f1)
    		(assert (Alumno(number ?number)(nota ?nota)(condition desprobado)))
    	)
)

