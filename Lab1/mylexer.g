lexer grammar mylexer;

options {
	language = Java;
}


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
LITERAL : '"' (options{greedy=false;}: .)* '"';
LITERAL_CHAR: '\''(options{greedy=false;}: .)*'\'';
HEADER: '#'(options{greedy=false;}: .)*'\n';


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
NULL: 'null'| '\\0';
NEW_LINE: '\n';
WS: (' '|'\r'|'\t')+;

