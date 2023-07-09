all:
	java -jar ./antlr-3.5.3-complete-no-st3.jar mylexer.g
	javac -cp ./antlr-3.5.3-complete-no-st3.jar:. *.java
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. testLexer test1.c
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. testLexer test2.c
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. testLexer test3.c
clean:
	rm *.class *.tokens mylexer.java
	
