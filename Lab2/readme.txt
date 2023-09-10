Compiler: Project_2
--------------------------------------

目標：
construct syntax analyzer(parser)

包含檔案：
subset_description.word --> contex free grammer+tokens
subset_description.pdf --> 因有放大量圖所以怕格式跑掉，這裡一起提供pdf方便助教批改 
myparser.g -->建立contex free grammer
testParser.java --> 用來測試
test.c test2.c test3. 測試檔案
makefile
antlr-3.5.3-complete-no-st3.jar

執行方式：
1. 將antlr-3.5.3-complete-no-st3.jar放至於同一個資料夾內
2. 直接下 make 即可執行並看到test test2 test3執行後的結果
3. 要移除剛剛產生的檔案下 make clean

學習內容：
首先，建立contex free grammer，並利用testLexer.java來測試執行是否正確。
這邊有做的功能包含:(9,10, 11, 12是與ecourse2不同額外多做的功能，詳細介紹可看"執行截圖和功能介紹.pdf")
1.if-then
2.if-else if
3.if-else if-else
4.for-loop
5.while-loop
6.支援基本的算術運算的statement。
7.至少支援下列的program construct
8.至少支援呼叫固定參數 (一個與兩個參數) 的printf function.
9.do-while loop
10. switch case
11. scanf
12. comment
