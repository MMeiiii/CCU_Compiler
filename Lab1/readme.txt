Compiler: Project_1
--------------------------------------

目標：
construct lexical analyzer

包含內容：
subset_description.docx
mylexer.g -->自訂的token（實際token請看subset_description.docx）
testLexer.java -->用來測試
test1.c test2.c test3. 測試檔案
makefile
antlr-3.5.3-complete-no-st3.jar

執行方式：
1. 將antlr-3.5.3-complete-no-st3.jar放至於同一個資料夾內
2. 直接下 make 即可執行並看到test1 test2 test3執行後的結果
3. 要移除剛剛產生的檔案下 make clean

學習內容：
首先，先定義好token並產生mylexer.g。
將mylexer.g使用ANTLR產生mylexer.tokens和mylexer.java。
編譯mylexer.java和testLexer.java產生java bytecode(.class)
最後把測試資料丟進testLexer.class即可執行。

