Compiler: Project_3
資工三 409410029 王美綺
--------------------------------------

目標：
type checker

包含檔案：
subset_description.word --> type checking rules + C subset
subset_description.pdf --> 因有放大量圖所以怕格式跑掉，這裡一起提供pdf方便助教批改 
myChecker.g --> type Checker rules
myChecker_test.java --> 用來測試
test.c test2.c test3. 測試檔案
makefile
antlr-3.5.3-complete-no-st3.jar

執行方式：
1. 將antlr-3.5.3-complete-no-st3.jar放至於同一個資料夾內
2. 直接下 make 即可執行並看到test test2 test3執行後的結果
3. 要移除剛剛產生的檔案下 make clean

學習內容：
先架構出type checker要包含哪些rule，再依rule去設計
這邊包含的rule：（7, 8, 9, 10）是額外多做的功能
(1) Each variable must be declared before it is used.
(2) Each identifier can be only declared once.
(3) The types of the operands of an operator must be the same.
(4) The types of the two sides of an assignment must be the same.
(5) ==、!=、>=、>、<=、< 等運算的結果，其 type 為 boolean.
(6) if-else、for-loop、while-loop constructs 的 condition 部分，其 type 必
須是 boolean，否則為 type error.
(7) printf參數與變數型態須相同
(8) scanf參數與變數型態須相同
(9) do while condition須是boolean
(10) switch (變數) {case(數字)...}變數和數字的型態須相同
