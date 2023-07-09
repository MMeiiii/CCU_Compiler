all:
	java -jar ./antlr-3.5.3-complete-no-st3.jar myCompiler.g
	javac -cp ./antlr-3.5.3-complete-no-st3.jar:. *.java
	
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. myCompiler_test test1.c
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. myCompiler_test test1.c > test1.ll
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. myCompiler_test test2.c
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. myCompiler_test test2.c > test2.ll
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. myCompiler_test test3.c
	java -cp ./antlr-3.5.3-complete-no-st3.jar:. myCompiler_test test3.c > test3.ll
	
clean:
	rm *.class myCompiler.tokens myCompilerLexer.java myCompilerParser.java *.ll
