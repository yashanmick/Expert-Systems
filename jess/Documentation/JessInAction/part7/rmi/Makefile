.SUFFIXES:	.java .class

# You'll need to change these to make your own system.
JAVA_HOME=/usr/java/j2sdk1.4.0
JESS=/home/ejfried/Jess/jess.jar

SRC=$(shell find . -name '*.java' -print )
OBJ=$(SRC:.java=.class)
STUBS=JessImpl_Stub.class JessImpl_Skel.class \
	JessFactoryImpl_Stub.class JessFactoryImpl_Skel.class

build: $(OBJ) $(STUBS)

JessImpl_Stub.class: $(OBJ)
	rmic JessImpl

JessFactoryImpl_Stub.class: $(OBJ)
	rmic JessFactoryImpl

.java.class:
	jikes +E -classpath .:$(JAVA_HOME)/jre/lib/rt.jar:$(JESS) $<


clean:
	rm -f *~ *.class


