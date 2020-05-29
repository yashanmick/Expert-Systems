#
# Simple test Makefile
#

include ../shelldefs.mk
.SUFFIXES: .java .class

.java.class :
	$(JAVAC) $(JAVACFLAGS)  $<


SRC =   test.java

OBJ = $(SRC:.java=.class)

Main: $(OBJ)

clean: 
	-@ rm -f *~ *.class

reallyclean: clean
	-@ rm -f *.out


