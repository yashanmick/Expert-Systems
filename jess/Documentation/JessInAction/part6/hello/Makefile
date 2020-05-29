.SUFFIXES:	.java .class

JAVA_HOME=/usr/java/j2sdk1.4.0
CATALINA_HOME=/home/ejfried/jakarta-tomcat-4.0.4
APPNAME=HelloJess
JESS=/home/ejfried/Jess/jess.jar

build: HelloJess.class Hello.class

.java.class:
	jikes -classpath .:$(JAVA_HOME)/jre/lib/rt.jar:$(CATALINA_HOME)/common/lib/servlet.jar:$(JESS) $<

install: build
	rm -rf $(CATALINA_HOME)/webapps/$(APPNAME)/*
	mkdir -p $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF
	cp web.xml $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF
	mkdir -p $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF/classes
	cp *.class $(CATALINA_HOME)/webapps/$(APPNAME)/WEB-INF/classes
	cp *.jsp $(CATALINA_HOME)/webapps/$(APPNAME)
	cp  $(JESS) $(CATALINA_HOME)/lib

clean:
	rm -f *~ *.class


