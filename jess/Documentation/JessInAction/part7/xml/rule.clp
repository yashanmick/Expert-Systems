 
    (defrule RuleName
        (declare (salience 1))
        (number (value ?x&:(or(= x 2)(= x 3))))
        (not 
          (number (value ?x&:(= x 3)))
        )      
      =>    
        (printout t ?x crlf)
      )

  