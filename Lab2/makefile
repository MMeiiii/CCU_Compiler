all:
	java -cp antlr-3.5.3-complete-no-st3.jar org.antlr.Tool myparser.g
	javac -cp antlr-3.5.3-complete-no-st3.jar:. *.java
	java -cp antlr-3.5.3-complete-no-st3.jar:. testParser test.c 
	java -cp antlr-3.5.3-complete-no-st3.jar:. testParser test2.c 
	java -cp antlr-3.5.3-complete-no-st3.jar:. testParser test3.c
clean:
	rm *.class
	rm myparserLexer.java
	rm myparserParser.java
	rm myparser.tokens
