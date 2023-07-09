grammar myChecker;

options{
  language = Java;
}

@header {
	import java.util.HashMap;
}

@members{
  boolean TRACEON = false;
  HashMap<String, Integer> symtab = new HashMap <String, Integer>();
}

program:HEADER VOID_TYPE MAIN'('')' '{' declarations statements '}';
		   	
declarations: 
	type ID 
	     {
	     	if(!symtab.containsKey($ID.text)){
		  symtab.put($ID.text, $type.attr_type);
	     	}
		else{
		  System.out.println("Error! " + $ID.getLine() + ": Redeclared identifier" );
		}
	     } ';' declarations
	| type ID
	     {
	     	if(!symtab.containsKey($ID.text)){
		  symtab.put($ID.text, $type.attr_type);
	     	}
		else{
		  System.out.println("Error! " + $ID.getLine() + ": Redeclared identifier" );
		}
	     } '=' declare_value 
	     		{
	     			if($type.attr_type != $declare_value.attr_type){
	     			   System.out.println("Error! " + $ID.getLine() + ": Type mismatch for the two sides of an assignment" );
	     			}
	     		}';' declarations
	|type ID
	     {
	     	if(!symtab.containsKey($ID.text)){
		  symtab.put($ID.text, $type.attr_type + 8);
	     	}
		else{
		  System.out.println("Error! " + $ID.getLine() + ": Redeclared identifier" );
		}
	     } '[' DEC_NUM ']' ';' declarations
	|;

type returns [int attr_type]: 
	(CONST_TYPE|UNSIGNED_TYPE|SIGNED_TYPE|ENUM_TYPE|VOLATILE_TYPE|STATIC_TYPE|) 
	(INT_TYPE { if (TRACEON) System.out.println("type: INT");  $attr_type = 1; }
       |FLOAT_TYPE { if (TRACEON) System.out.println("type: FLOAT"); $attr_type = 2; }
       |CHAR_TYPE { if (TRACEON) System.out.println("type: CHAR"); $attr_type = 3; }
       |VOID_TYPE { if (TRACEON) System.out.println("type: VOID"); $attr_type = 4; }
       |INT_TYPE '*'{ if (TRACEON) System.out.println("type: INT*");  $attr_type = 5; } 
       |FLOAT_TYPE '*'{ if (TRACEON) System.out.println("type: FLOAT*"); $attr_type = 6; }
       |CHAR_TYPE '*' { if (TRACEON) System.out.println("type: CHAR*"); $attr_type = 7;}
       |BOOLEAN_TYPE  { if (TRACEON) System.out.println("type: BOOLEAN"); $attr_type = 8;}
       );
       
declare_value returns [int attr_type]:
	DEC_NUM {$attr_type = 1; }
       |FLOAT_NUM {$attr_type = 2; }
       |ALPHA {$attr_type = 3; }
       ;
	
statements: statement statements
	   |;
	   
statement: 
	assignment_expression
      | boolean_assignment_expression
      | IF '(' (condition|compare) ')' '{' statements '}'ELSE '{' statements '}'
      | WHILE '(' (condition|compare) ')' '{' statements '}'
      | DO '{' statements '}' WHILE '(' (condition|compare) ')' ';' 
      | switch_expression
      | FOR '(' assignment_expression (condition|compare) ';' arith_expression ')' '{' statements '}'
      | PRINTF '(' '"' ps_f '"' ',' ID ')' ';'{if ($ps_f.attr_type != symtab.get($ID.text)) {System.out.println("Error! " + $ID.getLine() +": Type mismatch for the printf."); } }
      | SCANF '(' '"' ps_f '"' ',' '&' ID ')' ';'{if ($ps_f.attr_type != symtab.get($ID.text)) {System.out.println("Error! " + $ID.getLine() +": Type mismatch for the scanf."); } }
      ; 	

condition:
	ID {
	  if(!symtab.containsKey($ID.text)){
	   	System.out.println("Error! " + $ID.getLine() + ": Undeclared identifier" );
	   }
	  if(symtab.get($ID.text) != 8){
	  	System.out.println("Error! " + $ID.getLine() +": Type mismatch for the logical must return boolean.");
	  }
	};


boolean_assignment_expression:
	ID '=' compare { 
		if(!symtab.containsKey($ID.text)){
	 	   	System.out.println("Error! " + $ID.getLine() + ": Undeclared identifier" );
	        }
	
		if(symtab.get($ID.text) != $compare.attr_type)
			System.out.println("Error! " + $compare.start.getLine() +": Type mismatch for the logical must return boolean.");
		} ';';

     
ps_f returns [int attr_type]:
	 '%' 'd' {$attr_type = 1; }
       |'%' 'f' {$attr_type = 2; };

assignment_expression:
	ID '=' arith_expression ';' { 
		
		if (TRACEON) System.out.println("ID = arith_expression;"); 
		if(!symtab.containsKey($ID.text)){
		   	System.out.println("Error! " + $ID.getLine() + ": Undeclared identifier" );
	   	}
	   	else{
	   		if($arith_expression.attr_type != symtab.get($ID.text)){
				System.out.println("Error! " + $arith_expression.start.getLine() +": Type mismatch for the two sides of an assignment.");
			}
	   	
	   	}
	};

arith_expression returns [int attr_type]:
	a = multExpr{ $attr_type = $a.attr_type; } 
		('+' b = multExpr{ 
			if ($a.attr_type != $b.attr_type) {
				  System.out.println("Error! " + $a.start.getLine() +": Type mismatch for the operator + in an expression.");
				  $attr_type = -2;
			}
        	  }
        	|'-' c = multExpr{ 
			if ($a.attr_type != $c.attr_type) {
				  System.out.println("Error! " + $a.start.getLine() +": Type mismatch for the operator - in an expression.");
				  $attr_type = -2;
			}
		     }
		| PP_OP | MM_OP )*;

multExpr returns[int attr_type]:
	a = signExpr{ $attr_type = $a.attr_type; } 
		('*' b = signExpr{
			if($a.attr_type != $b.attr_type){
				  System.out.println("Error! " + $a.start.getLine() +": Type mismatch for the operator * in an expression.");
				  $attr_type = -2;	
			}
		} 
		|'/' c = signExpr{
			if ($a.attr_type != $c.attr_type) {
				  System.out.println("Error! " + $a.start.getLine() +": Type mismatch for the operator / in an expression.");
				  $attr_type = -2;
			}
		     }
		| '%' d = signExpr{
			if($a.attr_type != $d.attr_type){
				  System.out.println("Error! " + $a.start.getLine() +": Type mismatch for the operator / in an expression.");
				  $attr_type = -2;
			}
			
		}
		)* ;
	
signExpr returns [int attr_type]:
      primaryExpr { $attr_type = $primaryExpr.attr_type; }
      | '-' primaryExpr { $attr_type = $primaryExpr.attr_type; }
      ;
		  
primaryExpr returns [int attr_type]:
	DEC_NUM { $attr_type = 1; }
      | FLOAT_NUM { $attr_type = 2; }
      | ID { 
      	 if(!symtab.containsKey($ID.text)){
		System.out.println("Error! " + $ID.getLine() + ": Undeclared identifier" );
		$attr_type = -2;
	  }
	  else{
	  	$attr_type = symtab.get($ID.text); 
	  }
	 
	 }
      | '(' arith_expression ')' { $attr_type = $arith_expression.attr_type; }
      ;
      
compare returns[int attr_type]:
	a = ID op b = ID {
		if(!symtab.containsKey($a.text)) {
			System.out.println("Error! " + $a.getLine() + ": Undeclared identifier");		
			if(!symtab.containsKey($b.text)) { 
				System.out.println("Error! " + $b.getLine() + ": Undeclared identifier");
			}
			System.out.println("Error! " + $a.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else if(!symtab.containsKey($b.text)) { 
			System.out.println("Error! " + $b.getLine() + ": Undeclared identifier");
			System.out.println("Error! " + $b.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else if(symtab.get($a.text) != symtab.get($b.text)) {
			System.out.println("Error! " + $a.getLine() + ": Type mismatch for the operator");
			System.out.println("Error! " + $a.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else{
			$attr_type = 8;
		}	
	}
	| ID op num {
		if(!symtab.containsKey($ID.text)) {
			System.out.println("Error! " + $ID.getLine() + ": Undeclared identifier"); 	
			System.out.println("Error! " + $ID.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else if(symtab.get($ID.text) != $num.attr_type) {
			System.out.println("Error! " + $ID.getLine() + ": Type mismatch for the operator / in an expression.");
			System.out.println("Error! " + $ID.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else{
			$attr_type = 8;
		}
	} 
	| num op ID {
		if(!symtab.containsKey($ID.text)) {
			System.out.println("Error! " + $ID.getLine() + ": Undeclared identifier"); 	
			System.out.println("Error! " + $ID.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else if(symtab.get($ID.text) != $num.attr_type) {
			System.out.println("Error! " + $ID.getLine() + ": Type mismatch for the operator / in an expression.");
			System.out.println("Error! " + $ID.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else{
			$attr_type = 8;
		}
	}
	|  c = num op d = num {
		if($c.attr_type != $d.attr_type){
			System.out.println("Error! " + $c.start.getLine() + ": Type mismatch for the operator / in an expression.");
			System.out.println("Error! " + $c.start.getLine() + ": Condition return error, must return boolean" );
			$attr_type = -2;
		}
		else{
			$attr_type = 8;
		}
	};
	
op: LT_OP | GT_OP | LE_OP | GE_OP | EQ_OP | NE_OP;
num returns [int attr_type] :
				DEC_NUM {$attr_type = 1; }
			       |FLOAT_NUM {$attr_type = 2; };
			       
switch_expression: SWITCH '(' ID ')' '{'
		   CASE num ':' statements BREAK ';' {
			if(!symtab.containsKey($ID.text)){
				System.out.println("Error! " + $ID.getLine() + ": Undeclared identifier"); 	
			}
					
		   	if(symtab.get($ID.text) != $num.attr_type){
		   		System.out.println("Error! " + $num.start.getLine()+": Type mismatch for the switch case.");	
		   	
		   	}
		   }  (switch_case [symtab.get($ID.text)] )* DEFAULT ':' statements BREAK ';' '}';

val returns [int attr_type]:
			       DEC_NUM {$attr_type = 1; }
			      |FLOAT_NUM {$attr_type = 2; };

switch_case [int parent_type]:
	CASE num ':' statements BREAK ';' {
		if($parent_type != $num.attr_type){
			System.out.println("Error! " + $num.start.getLine() +": Type mismatch for the switch case.");
		}
	};	 			     

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
BOOLEAN_TYPE: 'bool';

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
PRINTF: 'printf';
ALPHA: '\'' 'a'..'z' | 'A'..'Z' '\'';
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
