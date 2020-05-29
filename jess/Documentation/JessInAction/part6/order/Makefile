.SUFFIXES:	.java .class

# You'll need to change these paths to match your own system.
JAVA_HOME=/usr/java/j2sdk1.4.0
CATALINA_HOME=/home/ejfried/jakarta-tomcat-4.0.4
APPNAME=Order
JESS=/home/ejfried/Jess/jess.jar

SRC=$(shell find . -name '*.java' -print )
OBJ=$(SRC:.java=.class)

build: $(OBJ)

.java.class:
	jikes +E -classpath .:$(JAVA_HOME)/jre/lib/rt.jar:$(CATALINA_HOME)/common/lib/servlet.jar:$(JESS) $<

install: build
	rm -rf $(CATALINA_HOME)/webapps/$(APPNAME)/*
	mkdir -p $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF
	cp web.xml $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF
	mkdir -p $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF/classes
	cp *.class *.clp $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF/classes
	cp *.jsp *.html $(CATALINA_HOME)/webapps/$(APPNAME)
	cp $(JESS) $(CATALINA_HOME)/lib

clean:
	rm -f *~ *.class


