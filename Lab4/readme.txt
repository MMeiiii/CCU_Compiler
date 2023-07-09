lli放壓縮檔裡(因檔案太大無法直接呈現)
Compiler: Project_4
資工三 409410029 王美綺
--------------------------------------

目標：
利用ANTLR製作compiler，並利用此compiler產生相對應的ll檔，最後利用llvm執行此ll檔


包含檔案：
subset_description.word
subset_description.pdf --> 因有放大量圖所以怕格式跑掉，這裡一起提供pdf方便助教批改 
myCompiler.g
myCompiler_test.java 
test1.c test2.c test3. 
makefile
antlr-3.5.3-complete-no-st3.jar
llvm(lli)
[補]:ll檔下make即可看見，沒有一開始就放裡面是因為怕會有是否真的由我寫的myCompiler.g產生的疑慮，故一開始沒有將ll檔放在裡面


執行方式：
1. 將antlr-3.5.3-complete-no-st3.jar及llvm和lli放在同一資料夾下(我都將其放在裡面了)
2. 直接下 make 即可看到test1.c test2.c test3.c產生出ll檔之內容
3. 要執行ll檔，分別下
	lli test1.ll(因為此裡面包含scanf故一開始請助教先輸入整數值)
	lli test2.ll
	lli test3.ll
4.刪除檔案下make clean


學習內容：
產生正確語法並利用llvm執行
這邊包含的rule：（6, 7, 8, 9, 10, 11, 12）是額外多做的功能
(1) Integer data types: int
(2) Statements for arithmetic computation. (e.g., a=b+2*(100-1);)
(3) Comparison expression. (e.g., a > b)，comparison operation: >、>=、<、<=、==、!=
(4) if-then / if-then-else program constructs.
(5) printf() function with one/two parameters. (support types: %d)
(6) Structure type: structure、float、char
(7) 可傳入一個整數變數並回傳一個整數變數的副程式
(8) 支援陣列
(9) 支援scanf
(10) 支援while
(11) 支援switch
(12) 支援for

[補]：有些功能有些許使用限制，都有在subset_description裡提到
