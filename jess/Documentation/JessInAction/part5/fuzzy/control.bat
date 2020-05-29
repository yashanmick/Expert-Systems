rem Requires Jess 6.1a3 or later and FuzzyJ/FuzzyJess 1.3 or later
rem
rem access a version of java ... 1.2 or later
rem classpath should allow access to the Jess class files 
rem          (e.g. jess.jar or the jess directory like f:\jess61)
rem classpath should allow access to the FuzzyJ/FuzzyJess class files 
rem          (e.g. fuzzyj13.jar or the directory nrc.fuzzy diectory like f:\fuzzyjtoolkit)
rem use the fuzzy console (or FuzzyMain) NOT the standard Jess console (or Jess Main))

d:\javasoft\jdk1.4\jre\bin\java -classpath f:\jess61p3\jess.jar;.\;f:\fuzzyjtoolkit nrc.fuzzy.jess.FuzzyConsole -batch "control.clp"
