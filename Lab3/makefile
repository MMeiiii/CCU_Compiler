all:
	java -cp antlr-3.5.3-complete-no-st3.jar \org.antlr.Tool myChecker.g
	javac -cp antlr-3.5.3-complete-no-st3.jar:. myChecker_test.java
	java -cp antlr-3.5.3-complete-no-st3.jar:. myChecker_test test1.c
	java -cp antlr-3.5.3-complete-no-st3.jar:. myChecker_test test2.c
	java -cp antlr-3.5.3-complete-no-st3.jar:. myChecker_test test3.c
clean:
	rm *.class myCheckerLexer.java myCheckerParser.java myChecker.tokens
