/*
;;variable decleration

;;local variables
(bind ?x "The value")
?x

;;global variables
(defglobal ?*x* = 3)
?*x*

*/

/*
(defglobal ?*x* = 3)
?*x*
(bind ?*x* 4)
(reset)
?*x*
(printout t "The answer is " ?*x* "!" crlf)
*/

/*
;;for loops
(bind ?i 3)
(while (> ?i 0)
	(printout t ?i crlf)
	(-- ?i))
*/

/*
;;if-else
(bind ?x 101)

(if (> ?x 100) then
	(printout t "X is big" crlf)
elif(> ?x 50) then
	(printout t "X is medium" crlf)
else
	(printout t "X is small" crlf)
)
*/

;;define functons
(deffunction max (?a ?b)
	(if (> ?a ?b) then
		(return ?a)
	else
		(return ?b)
	)
)

(printout t "The grater of 3 and 5 is "(max 3 5) "." crlf)

