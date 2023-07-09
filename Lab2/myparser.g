grammar myparser;

options{
  language = Java;
}

@header{
  //import packages here.
}

@members{
  boolean TRACEON = true;
}

program:HEADER{{ if (TRACEON) System.out.println("HEADER"); }} (struct | typedef | define)* VOID_TYPE MAIN'('')' '{' declarations statements RETURN DEC_NUM ';' '}'
	{ if (TRACEON) System.out.println("VOID MAIN() {declarations statements return 0}"); };

declarations: type ID (',' ID)* ';' declarations
	      { if (TRACEON) System.out.println("declartions: type ID, ID,... : declarations"); }
	    | type ID '=' ('-'|) (DEC_NUM|FLOAT_NUM) (',' ID '=' ('-'|) (DEC_NUM|FLOAT_NUM))*';' declarations 
	      { if (TRACEON) System.out.println("declarations: type ID = NUM, ID = NUM,...: declarations"); }
	    | type ID ('[' DEC_NUM ']') (',' ID ('[' DEC_NUM ']'))* ';' declarations
	      { if (TRACEON) System.out.println("declarations:type (ID[])* ");} 
	    | { if (TRACEON) System.out.println("declarations: ");} ;
	    
	    	    
type: (CONST_TYPE|UNSIGNED_TYPE|SIGNED_TYPE|ENUM_TYPE|VOLATILE_TYPE|STATIC_TYPE|) 
    (INT_TYPE ('*')* { if (TRACEON) System.out.println("type: INT"); } 
    |FLOAT_TYPE ('*')*  { if (TRACEON) System.out.println("type: FLOAT"); }
    |CHAR_TYPE ('*')*  { if (TRACEON) System.out.println("type: CHAR"); }
    |DOUBLE_TYPE ('*')*  { if (TRACEON) System.out.println("type: DOUBLE"); }
    |SHORT_TYPE ('*')*  { if (TRACEON) System.out.println("type: SHORT"); }
    |LONG_TYPE ('*')*  { if (TRACEON) System.out.println("type: LONG"); }
    |VOID_TYPE ('*')*  { if (TRACEON) System.out.println("type: VOID"); });
    
  
struct: STRUCT_TYPE ID '{' declarations '}' ';' { if (TRACEON) System.out.println("type: STRUCT"); };
typedef: TYPEDEF type ID ';' { if (TRACEON) System.out.println("type: typedef"); };
define: '#' DEFINE ID (FLOAT_NUM|DEC_NUM) { if (TRACEON) System.out.println("type: define"); };
statements: statement statements
	   |;
	   
statement: ID '=' arith_expression ';' 
	  { if (TRACEON) System.out.println("ID = arith_expression;"); }
	 | ID (PA_OP|MIA_OP) ID ';' 
	  { if (TRACEON) System.out.println("ID(+|-)=ID"); }
	 | ID (PP_OP|MM_OP|MUA_OP|DA_OP|MOA_OP) ';'
	  { if (TRACEON) System.out.println("ID(++|--)"); }
	 | IF '(' arith_expression ')' '{' statements (BREAK ';'|CONTINUE';'|)'}' (ELSE IF '(' arith_expression')' '{' statements (BREAK ';'|CONTINUE';'|) '}')* (ELSE '{' statements (BREAK';'|CONTINUE';'|) '}'|)
	  { if (TRACEON) System.out.println("if if-elseif if-elseif-else"); }  
	 | FOR '(' (((type|) ID '=' ('-'|) (DEC_NUM|FLOAT_NUM))|) ';' (arith_expression|) ';' (arith_expression|) ')' '{' statements '}'
	  { if (TRACEON) System.out.println("for(type ID = NUM; arith_expression; arith_expression) for(;;)"); }
	 | WHILE '(' arith_expression ')' '{' statements (BREAK|CONTINUE|) '}'
	  { if (TRACEON) System.out.println("while(arith_expression) {statements (break|continue|)}");}
	 | SWITCH '(' ID ')' '{' ((CASE (ID | (('-'|)(DEC_NUM|FLOAT_NUM))) ':')* statements BREAK ';')* (DEFAULT ':' statements BREAK ';'|) '}'
	  { if (TRACEON) System.out.println("switch(ID){ (case ID|NUM: statements break;)* default: statements break;");}
	 | DO '{' statements '}' WHILE '(' arith_expression ')' ';' 
	  { if (TRACEON) System.out.println("do{ statements } while(arith_expression);");}
	 | PRINTf '(' '"'  printf_expression ')' ';' 
	  { if (TRACEON) System.out.println("printf(literal,ID*)");}
	 | SCANF '(' '"'  scanf_expression ')'';' 
	  { if (TRACEON) System.out.println("scanf(literal,&ID*)");}
	 | (COMMENT1 | COMMENT2)
	  { if (TRACEON) System.out.println("COMMENT");}
	 | PRINTf '(' '"'  (ID|DEC_NUM|FLOAT_NUM) (ID|DEC_NUM|FLOAT_NUM)* '"' ')' ';'{ if (TRACEON) System.out.println("printf(text)");};
	  
arith_expression: ('!' | '~')* multExpr( '+' multExpr | '-' multExpr | '<' multExpr | '>' multExpr | LE_OP multExpr | '>''=' multExpr | EQ_OP multExpr | ('&'('&'|) multExpr) | ('|'('|'|) multExpr) | '!''=' multExpr | PP_OP | MM_OP | RSHIFT_OP| LSHIFT_OP |CARET_OP | ARROW_OP)*;
multExpr: signExpr ('*' signExpr | '/' signExpr | '%' signExpr)*;
signExpr: primaryExpr | '-' primaryExpr;
primaryExpr: DEC_NUM | FLOAT_NUM | ID | '(' arith_expression ')';

printf_expression: (PRINTF_D|PRINTF_F) printf_expression b | '"';
scanf_expression: (PRINTF_D|PRINTF_F) scanf_expression bb| '"';
b: ',' ID;
bb: ',''&' ID;
PRINTF_D:'%d';
PRINTF_F:'%f';

/*--------------------------*/
/*	Reserved word	     */
/*--------------------------*/
RETURN: 'return';
DEFINE: 'define';
TYPEDEF: 'typedef';
SIZEOF: 'sizeof';

/*--------------------------*/
/*	  Data Type	     */
/*--------------------------*/
CHAR_TYPE: 'char';
INT_TYPE: 'int';
SHORT_TYPE: 'short';
LONG_TYPE: 'long';
CONST_TYPE: 'const';
FLOAT_TYPE: 'float';
DOUBLE_TYPE: 'double';
UNSIGNED_TYPE: 'unsigned';
SIGNED_TYPE: 'signed';
STRUCT_TYPE: 'struct';
VOID_TYPE: 'void';
STATIC_TYPE: 'static';
VOLATILE_TYPE: 'volatile';
ENUM_TYPE: 'enum';

/*--------------------------*/
/*	  Comment	     */
/*--------------------------*/
COMMENT1: '//'(.)*'\n';
COMMENT2: '/*' (options{greedy=false;}: .)* '*/';

/*--------------------------*/
/*	  Operators	     */
/*--------------------------*/
LT_OP: '<';
GT_OP: '>';
LE_OP: '<=';
GE_OP: '>=';
EQ_OP: '==';
NE_OP: '!=';
PLUS_OP: '+';
PP_OP: '++';
MINUS_OP: '-';
MM_OP: '--';
MULTIPLE_OP: '*';
DIVID_OP: '/';
MOD_OP: '%';
RSHIFT_OP: '>>';
LSHIFT_OP: '<<';
ASSIGN_OP: '=';
PA_OP: '+=';
MIA_OP: '-=';
MUA_OP: '*=';
DA_OP: '/=';
MOA_OP: '%=';
BITAND_OP: '&';
BITOR_OP: '|';
AND_OP: '&&';
OR_OP: '||';
NOT_OP: '!';
QUESTION_OP: '?';
ARROW_OP: '->';
WAVE_OP: '~';
CARET_OP: '^';

/*--------------------------*/
/*	  SYMBOL	     */
/*--------------------------*/
COMMA: ',';
SEMICOLON: ';';
LEFT_PAREM: '(';
RIGHT_PAREM: ')';
LEFT_BRACE: '{';
RIGHT_BRACE: '}';
LEFT_BRACKET: '[';
RIGHT_BRACKET: ']';
DOT: '.';
COLON: ':';

/*--------------------------*/
/*	  CONTROL	     */
/*--------------------------*/
IF: 'if';
ELSE: 'else';
BREAK: 'break';
WHILE: 'while';
EOF_: 'EOF';
FOR: 'for';
DO: 'do';
SWITCH: 'switch';
CASE: 'case';
CONTINUE: 'continue';
DEFAULT: 'default';

/*--------------------------*/
/*      Special Function    */
/*--------------------------*/
MAIN: 'main';
SCANF: 'scanf';
PRINTf: 'printf';
//LITERAL : '"'(options{greedy=false;}: .)* '"';
LITERAL_CHAR: '\''(options{greedy=false;}: .)*'\'';
HEADER: '#''include <stdio.h>''\n';
//HEADER1: '<stdio.h>';

/*--------------------------*/
/*      Number & ID 	     */
/*--------------------------*/
DEC_NUM: ('0' | ('1'..'9')(DIGIT)*);
ID: (LETTER)(LETTER|DIGIT)*;
fragment LETTER : 'a'..'z' | 'A'..'Z' | '_';
fragment DIGIT : '0'..'9';
FLOAT_NUM: FLOAT_NUM1 | FLOAT_NUM2 | FLOAT_NUM3;
fragment FLOAT_NUM1: (DIGIT)+'.'(DIGIT)*;
fragment FLOAT_NUM2: '.'(DIGIT)+;
fragment FLOAT_NUM3: (DIGIT)+;

/*--------------------------*/
/*        Blank 	     */
/*--------------------------*/
NULL: 'null'| '\\0'{$channel=HIDDEN;};
NEW_LINE: '\n'{$channel=HIDDEN;};
WS: (' '|'\r'|'\t')+{$channel=HIDDEN;};

