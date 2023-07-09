grammar myCompiler;

options {
 language = Java;
}

@header {
 import java.util.HashMap;
 import java.util.ArrayList;
 import java.util.stream.Collectors;
 import java.util.stream.IntStream;
}

@members{

 boolean TRACEON = false;
 
 int var_count = 1;
 int print_num = 3; //insert TextCode
 int string_num = 0;
 int Ltrue_count = 1, Lfalse_count = 1, Lend_count = 1, Jump_num = 1;
 int cond_num = 0;
 
class tVar{
	int   varIndex; // temporary variable's index. Ex: t1, t2, ..., etc.
	int   iValue;   // value of constant integer. Ex: 123.
	float fValue;   // value of constant floating point. Ex: 2.314.
};

 
 class Info{
 	int theType; /* int = 0, float = 1, char = 2, const_int = 3 */
 	tVar var_num;
 	int array_size;
 	
 	Info(){
 	 theType = -1;
 	 var_num = new tVar();
 	 array_size = 0;
 	}
 };
 
 HashMap<String, Info> symtab = new HashMap<String, Info>();
 
 // Record all assembly instructions.
 List<String> TextCode = new ArrayList<String>();
 
 //------------struct--------------------
   class struct_1_Info{
   	int type_1;
   	int index_1;
   	
   	struct_1_Info(){
   		type_1 = -1;
   		index_1 = -1;
   	}
   };
int struct_index = 0;
HashMap<String, struct_1_Info> struct_2_Info = new HashMap<String, struct_1_Info>();
HashMap<String, HashMap> struct_3_Info = new HashMap<String, HashMap>();
ArrayList<Integer> type_bits = new ArrayList<Integer>();
 
 
 void prologue()
 {
 	TextCode.add(";===prologue===");
 	TextCode.add("declare dso_local i32 @__isoc99_scanf(i8*, ...)"); //scanf
 	TextCode.add("declare dso_local i32 @printf(i8*, ...)"); //printf
 }
 void epilogue()
 {
	 TextCode.add("ret i32 0");
	 TextCode.add("}");
	 TextCode.add("\n; === epilogue ===");
 }
 
 public List<String> getTextCode()
 {
       return TextCode;
 }

}

program: {prologue();} 
	 global_space
	 INT MAIN '(' VOID ')'
	 {
	 	TextCode.add("\ndefine dso_local i32 @main()");
	 	TextCode.add("{");
	 }
	 '{'
	 local_space
	 (RETURN DEC_NUM ';'|)
	 '}'
	 {epilogue();};
	 
global_space: (structs)* declare[0] (subroutine)*;
local_space: declare[1] statements;

declare [int flag]: type ID {
		Info the_entry = new Info();
		the_entry.theType = $type.attr;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		symtab.put($ID.text, the_entry);
		
		if(flag == 0){
			if(the_entry.theType == 0){
				TextCode.add("@" + $ID.text + " = dso_local global i32 0, align 4");
			}
			else if(the_entry.theType == 1){
				TextCode.add("@" + $ID.text + " = dso_local global float 0.000000e+00, align 4");
			}
			else if(the_entry.theType == 2){
				TextCode.add("@" + $ID.text + " = dso_local global i8 0, align 1");
			}
		
		}
		else if(flag == 1){
			if(the_entry.theType == 0){
				TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
			}
			else if(the_entry.theType == 1){
				TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
			}
			else if(the_entry.theType == 2){
				TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i8, align 1");
			}
		
		}
		
	  } first_declares [$type.attr, $flag] declare[$flag] /* first_declares: int a, b, c; */
	  | type ID '=' DEC_NUM 
	    {
	    	Info the_entry = new Info();
		the_entry.theType = $type.attr;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		symtab.put($ID.text, the_entry);
		
		if(flag == 0){
			TextCode.add("@" + $ID.text + " = dso_local global i32 " +  $DEC_NUM.text + ", align 4");
		}
		else if(flag == 1){
			TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
              		TextCode.add("store i32 " + $DEC_NUM.getText() + ", i32* \%t" + the_entry.var_num.varIndex + ", align 4");
		}
	    } second_declares [$type.attr, $flag] declare[$flag]  /* second_declares: int a = 2, b = 5; */
	   | type ID '=' FLOAT_NUM
	     {
	    	Info the_entry = new Info();
		the_entry.theType = $type.attr;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		 symtab.put($ID.text, the_entry);
		 
		 if(flag == 0){
		 	TextCode.add("@" + $ID.text + " = dso_local global i32 " +  $FLOAT_NUM.text + ", align 4");
		 }
		 else if(flag == 1){
		 	TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
              	 	TextCode.add("store i32 " + $FLOAT_NUM.getText() + ", i32* \%t" + the_entry.var_num.varIndex + ", align 4");
		 }
	     } third_declares [$type.attr, $flag] declare[$flag] /* third_declares: int a = 0.2, b = 0.5; */
	   | type a = ID '=' '\'' b = ID '\''
	     {
	    	Info the_entry = new Info();
		the_entry.theType = $type.attr;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		symtab.put($a.text, the_entry);
		
		if(flag == 0){
			TextCode.add("@" + $a.text + " = dso_local global i8 " +  $b.text + ", align 1");
		}
		else if( flag == 1){
			TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i8, align 1");
              		TextCode.add("store i8 " + $b.getText() + ", i8* \%t" + the_entry.var_num.varIndex + ", align 1");
		}
	     } forth_declares [$type.attr, $flag] declare[$flag] /* forth_declares: char a = 'c', b = 'd'; */
	    | type ID '[' DEC_NUM ']' ';'
	      {
	    	 Info the_entry = new Info();
		 the_entry.theType = $type.attr;
		 if(flag == 0){
			the_entry.var_num.varIndex = -1;
		 }
		 else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		 }
		 the_entry.array_size = Integer.parseInt($DEC_NUM.text);
		 symtab.put($a.text, the_entry);
		 if(flag == 0){
		 	 TextCode.add("@" + $ID.text + " = dso_local global [" + $DEC_NUM.text + " x i32] zeroinitializer, align 4");
		 }
		 else if(flag == 1){
		 	 TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca [" + $DEC_NUM.text + " x i32], align 4");
		 }
	     } declare [$flag]
	   | type ID '[' a = DEC_NUM ']' '=' '{' b = DEC_NUM ',' c = DEC_NUM ',' d = DEC_NUM
	     {
	     	Info the_entry = new Info();
		the_entry.theType = $type.attr;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		the_entry.array_size = Integer.parseInt($a.text);
		symtab.put($ID.text, the_entry);
		
		if(flag == 0){
			TextCode.add("@" + $ID.text + " = dso_local global [" + $a.text + " x i32] [i32 " + $b.text + ", i32 " + $c.text + ", i32 " + $d.text + "]");
		}	     
	     } '}' ';' declare [$flag]
	   | type ID '=' '-' DEC_NUM 
	    {
	    	Info the_entry = new Info();
		the_entry.theType = $type.attr;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		symtab.put($ID.text, the_entry);
		
		if(flag == 0){
			TextCode.add("@" + $ID.text + " = dso_local global i32 -" +  $DEC_NUM.text + ", align 4");
		}
		else if(flag == 1){
			TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
              		TextCode.add("store i32 -" + $DEC_NUM.getText() + ", i32* \%t" + the_entry.var_num.varIndex + ", align 4");
		}
	    } second_declares [$type.attr, $flag] declare[$flag]  /* second_declares: int a = 2, b = 5; */
	    | ;
	  
	     	  
first_declares [int parent_type, int flag]: ',' ID
	{		
		Info the_entry = new Info();
		the_entry.theType = parent_type;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		symtab.put($ID.text, the_entry);
		
		if(flag == 0){
			if(the_entry.theType == 0){
				TextCode.add("@" + $ID.text + " = dso_local global i32 0, align 4");
			}
			else if(the_entry.theType == 1){
				TextCode.add("@" + $ID.text + " = dso_local global float 0.000000e+00, align 4");
			}
			else if(the_entry.theType == 2){
				TextCode.add("@" + $ID.text + " = dso_local global i8 0, align 1");
			}
		
		}
		else if(flag == 1){
			if(the_entry.theType == 0){
				TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
			}
			else if(the_entry.theType == 1){
				TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
			}
			else if(the_entry.theType == 2){
				TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i8, align 1");
			}
		
		}
	} first_declares [$parent_type, $flag]
	| ';';
	
second_declares [int parent_type, int flag]: ',' ID '=' DEC_NUM
	{
		Info the_entry = new Info();
		the_entry.theType = parent_type;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		symtab.put($ID.text, the_entry);
		if(flag == 0){
			TextCode.add("@" + $ID.text + " = dso_local global i32 " +  $DEC_NUM.text + ", align 4");
		}
		else if(flag == 1){
			TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
              		TextCode.add("store i32 " + $DEC_NUM.getText() + ", i32* \%t" + the_entry.var_num.varIndex + ", align 4");
		}
	
	} second_declares [$parent_type, $flag]
	| ';';
	
third_declares [int parent_type, int flag]: ',' ID '=' FLOAT_NUM
	{
		Info the_entry = new Info();
		the_entry.theType = parent_type;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		 symtab.put($ID.text, the_entry);
		 
		 if(flag == 0){
		 	TextCode.add("@" + $ID.text + " = dso_local global i32 " +  $FLOAT_NUM.text + ", align 4");
		 }
		 else if(flag == 1){
		 	TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i32, align 4");
              	 	TextCode.add("store i32 " + $FLOAT_NUM.getText() + ", i32* \%t" + the_entry.var_num.varIndex + ", align 4");
		 }
	
	} third_declares [$parent_type, $flag]
	| ';';
	
forth_declares [int parent_type, int flag]: ',' a = ID '=' '\'' b = ID '\''
	{
	    	Info the_entry = new Info();
		the_entry.theType = parent_type;
		if(flag == 0){
			the_entry.var_num.varIndex = -1;
		}
		else if(flag == 1){
			the_entry.var_num.varIndex = var_count;
			var_count ++;
		}
		symtab.put($a.text, the_entry);
		
		if(flag == 0){
			TextCode.add("@" + $a.text + " = dso_local global i8 " +  $b.text + ", align 1");
		}
		else if( flag == 1){
			TextCode.add("\%t" + the_entry.var_num.varIndex + " = alloca i8, align 1");
              		TextCode.add("store i8 " + $b.getText() + ", i8* \%t" + the_entry.var_num.varIndex + ", align 1");
		}
		
	} forth_declares [$parent_type, $flag]
	| ';';
	
structs: STRUCT ID '{' (struct_declartion)* '}' ';'  
	{ 
	  if (TRACEON) System.out.println("type: STRUCT"); 
	  struct_3_Info.put($ID.text, struct_2_Info); 
	  TextCode.add("\%struct." + $ID.text + " = type { i" + type_bits.get(0) + ", i" + type_bits.get(1) + ", i" + type_bits.get(2) + " }");
	  struct_index = 0; 
	  struct_2_Info.clear();
	  type_bits.clear(); 
	};

struct_declartion: struct_type ID ';'
		   {
		     struct_1_Info the_entry = new struct_1_Info();
		     the_entry.type_1 = $struct_type.attr_type;
		     the_entry.index_1 = struct_index;
		     struct_index++;
		     struct_2_Info.put($ID.text, the_entry);
		     type_bits.add(the_entry.type_1);
		   };
		   
struct_type returns [int attr_type]: 
      INT { if (TRACEON) System.out.println("type: INT"); $attr_type= 32; }
    | CHAR { if (TRACEON) System.out.println("type: CHAR"); $attr_type= 8; }
    | FLOAT {if (TRACEON) System.out.println("type: FLOAT"); $attr_type= 32; };
	
type returns [int attr]
    : INT { if (TRACEON) System.out.println("type: INT"); $attr = 0; }
    | CHAR { if (TRACEON) System.out.println("type: CHAR"); $attr = 2; }
    | FLOAT {if (TRACEON) System.out.println("type: FLOAT"); $attr = 1; };
    
subroutine: INT b = ID '(' INT d = ID ')'
	{
		TextCode.add("\ndefine dso_local i32 @" + $b.text + "(i32 \%t" + var_count + ") {");
		Info the_entry = new Info();
		the_entry.theType = 0;
		the_entry.var_num.varIndex = var_count + 1;
		symtab.put($d.text, the_entry);
		var_count ++;
		TextCode.add("\%t" + var_count + " = alloca i32, align 4");
		TextCode.add("store i32 \%t" + (var_count-1) + ", i32* \%t" + var_count + ", align 4");
		var_count ++;
		
	}'{' declare[1] statements '}'
	{
		TextCode.add("}");
	};
	
statements: statement statements
	   |;
	 
statement: assign_stmt ';'
	  | printf_stmt ';'
	  | if_else_stmt {
	  	if($if_else_stmt.if_flag == 0){
	      	TextCode.set($if_else_stmt.size-1, "br i1 \%cond"+ cond_num +", label \%Ltrue" + (Ltrue_count-1) + ", label \%Lend" + Lend_count);
	  	}
	  	cond_num ++;
	  	TextCode.add("\nLend" + Lend_count + ":");
	  	Lend_count ++;
	    }
	  | scanf_stmt ';'
	  | while_stmt
	  | switch_stmt
	  | for_stmt{cond_num++;}
	  | return_stmt ';'
	  | sub_ ';'
	  ;
	  
return_stmt: RETURN ID{
	
	int temp = symtab.get($ID.text).var_num.varIndex;
	TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp + ", align 4");
	TextCode.add("ret i32 \%t" + var_count);
	var_count ++;
};

sub_: a = ID '=' b = ID '(' c = ID ')'{
		
	int temp = symtab.get($c.text).var_num.varIndex;
	int temp_1 = symtab.get($a.text).var_num.varIndex;
	TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp + ", align 4");
	var_count ++;
	TextCode.add("\%t" + var_count + " = call i32 @" + $b.text + "(i32 \%t" + (var_count-1) +  ")" );
	TextCode.add("store i32 \%t" + var_count + ", i32* \%t" + temp_1 + ", align 4");
	var_count ++;

};


assign_stmt: ID '=' arith_expression
	{
		Info theRHS = $arith_expression.theInfo;
		Info theLHS = symtab.get($ID.text);
		int flag = theLHS.var_num.varIndex;
		
		if((theRHS.theType == 0) && (theLHS.theType == 0)){
			if(flag == -1){
				TextCode.add("store i32 \%t" + theRHS.var_num.varIndex + ", i32* @" + $ID.text + ", align 4");
			}
			else{
				TextCode.add("store i32 \%t" + theRHS.var_num.varIndex + ", i32* \%t" + theLHS.var_num.varIndex + ", align 4");
			}
		}
		else if((theLHS.theType == 0) && (theRHS.theType == 3)){
			if(flag == -1){
				TextCode.add("store i32 " + theRHS.var_num.iValue + ", i32* @" + $ID.text + ", align 4");
			}
			else{
				TextCode.add("store i32 " + theRHS.var_num.iValue + ", i32* \%t" + theLHS.var_num.varIndex + ", align 4");
			}	
		}	
	};
	
arith_expression returns [Info theInfo]@init{theInfo = new Info();}:
	a = multExpr{$theInfo = $a.theInfo; }
	( '+' b = multExpr
	   {	
	   	if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 0)){
	   		 TextCode.add("\%t" + var_count + " = add nsw i32 \%t" + $theInfo.var_num.varIndex + ", \%t" + $b.theInfo.var_num.varIndex);
	   		 $theInfo.theType = 0;
			 $theInfo.var_num.varIndex = var_count;
			 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 3)){
	   		
	   		 TextCode.add("\%t" + var_count + " = add nsw i32 \%t" + $theInfo.var_num.varIndex + ", " + $b.theInfo.var_num.iValue);
	   		 $theInfo.theType = 0;
	   		 $theInfo.var_num.varIndex = var_count;
	   		 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 3)){
	   		 $theInfo.theType = 3;
	   		 $theInfo.var_num.iValue = $a.theInfo.var_num.iValue + $b.theInfo.var_num.iValue;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 0)){
	   		TextCode.add("\%t" + var_count + " = add nsw i32 " + $a.theInfo.var_num.iValue + ", \%t" + $b.theInfo.var_num.varIndex);
	   		$theInfo.theType = 0;
	   		$theInfo.var_num.varIndex = var_count;
	   		var_count ++;
	   	}
	   }
	 | '-' b = multExpr
	    {
	    	if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 0)){
	   		 TextCode.add("\%t" + var_count + " = sub nsw i32 \%t" + $theInfo.var_num.varIndex + ", \%t" + $b.theInfo.var_num.varIndex);
	   		 $theInfo.theType = 0;
			 $theInfo.var_num.varIndex = var_count;
			 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 3)){
	   		 TextCode.add("\%t" + var_count + " = sub nsw i32 \%t" + $theInfo.var_num.varIndex + ", " + $b.theInfo.var_num.iValue);
	   		 $theInfo.theType = 0;
	   		 $theInfo.var_num.varIndex = var_count;
	   		 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 3)){
	   		 $theInfo.theType = 3;
	   		 $theInfo.var_num.iValue = $a.theInfo.var_num.iValue - $b.theInfo.var_num.iValue;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 0)){
	   		TextCode.add("\%t" + var_count + " = sub nsw i32 " + $a.theInfo.var_num.iValue + ", \%t" + $b.theInfo.var_num.varIndex);
	   		$theInfo.theType = 0;
	   		$theInfo.var_num.varIndex = var_count;
	   		var_count ++;
	   	}
	    }
	 )*;
	 
multExpr returns[Info theInfo] @init {theInfo = new Info();}:
	a = signExpr {$theInfo = $a.theInfo;}
	( '*' b = signExpr
	   {
	   	if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 0)){
	   		 TextCode.add("\%t" + var_count + " = mul nsw i32 \%t" + $theInfo.var_num.varIndex + ", \%t" + $b.theInfo.var_num.varIndex);
	   		 $theInfo.theType = 0;
			 $theInfo.var_num.varIndex = var_count;
			 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 3)){
	   		 TextCode.add("\%t" + var_count + " = mul nsw i32 \%t" + $theInfo.var_num.varIndex + ", " + $b.theInfo.var_num.iValue);
	   		 $theInfo.theType = 0;
	   		 $theInfo.var_num.varIndex = var_count;
	   		 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 3)){
	   		 $theInfo.theType = 3;
	   		 $theInfo.var_num.iValue = $a.theInfo.var_num.iValue * $b.theInfo.var_num.iValue;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 0)){
	   		TextCode.add("\%t" + var_count + " = mul nsw i32 " + $a.theInfo.var_num.iValue + ", \%t" + $b.theInfo.var_num.varIndex);
	   		$theInfo.theType = 0;
	   		$theInfo.var_num.varIndex = var_count;
	   		var_count ++;
	   	}	   	
	   }
	 | '/' b = signExpr
	    {
	   	if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 0)){
	   		 TextCode.add("\%t" + var_count + " = sdiv i32 \%t" + $theInfo.var_num.varIndex + ", \%t" + $b.theInfo.var_num.varIndex);
	   		 $theInfo.theType = 0;
			 $theInfo.var_num.varIndex = var_count;
			 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 0) && ($b.theInfo.theType == 3)){
	   		 TextCode.add("\%t" + var_count + " = sdiv i32 \%t" + $theInfo.var_num.varIndex + ", " + $b.theInfo.var_num.iValue);
	   		 $theInfo.theType = 0;
	   		 $theInfo.var_num.varIndex = var_count;
	   		 var_count ++;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 3)){
	   		 $theInfo.theType = 3;
	   		 $theInfo.var_num.iValue = $a.theInfo.var_num.iValue / $b.theInfo.var_num.iValue;
	   	}
	   	else if(($a.theInfo.theType == 3) && ($b.theInfo.theType == 0)){
	   		TextCode.add("\%t" + var_count + " = sdiv nsw i32 " + $a.theInfo.var_num.iValue + ", \%t" + $b.theInfo.var_num.varIndex);
	   		$theInfo.theType = 0;
	   		$theInfo.var_num.varIndex = var_count;
	   		var_count ++;
	   	}	    		    
	    }
	)*;
	
signExpr returns [Info theInfo] @init{theInfo = new Info();}:
          a = primaryExpr { $theInfo = $a.theInfo; } 
        | '-' b = primaryExpr { 
           if($b.theInfo.theType == 0){
           	TextCode.add("\%t" + var_count + " = sub nsw i32 0, " + $b.theInfo.var_num.varIndex);
           	$theInfo.var_num.varIndex = var_count;
           	$theInfo.theType = 0;
           	var_count ++;
           }
           else if($b.theInfo.theType == 1){
           	TextCode.add("\%t" + var_count + " = fneg float \%t" + $b.theInfo.var_num.varIndex);
           	$theInfo.theType = 1;
           	var_count ++;
           }
        };
	
primaryExpr returns [Info theInfo] @init {theInfo = new Info();}:
            DEC_NUM
	    {
            	$theInfo.theType = 3;
		$theInfo.var_num.iValue = Integer.parseInt($DEC_NUM.text);
            }
          | FLOAT_NUM
            {
            	$theInfo.theType = 4;
            	$theInfo.var_num.fValue =  Float.parseFloat($FLOAT_NUM.text);
            }
          | ID
              {
                int the_type = symtab.get($ID.text).theType;
                int flag = symtab.get($ID.text).var_num.varIndex;
                $theInfo.theType = the_type;
		
                int vIndex = symtab.get($ID.text).var_num.varIndex;
				
                switch (the_type) {
                case 0: 
                	 if(flag == -1){
                	 	TextCode.add("\%t" + var_count + " = load i32, i32* @" + $ID.text + ", align 4 ");
                	 }else{
                	 	TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + vIndex + ", align 4 ");	 
                	 }        			
                	 $theInfo.var_num.varIndex = var_count;
			 var_count ++;
                        break;
                case 1:
                	 if(flag == -1){
                	 	TextCode.add("\%t" + var_count + " = load float, float* @" + $ID.text + ", align 4 ");
                	 }
                	 else{
                	 	TextCode.add("\%t" + var_count + " = load float, float* \%t" + vIndex + ", align 4 ");
                	 }
                	 $theInfo.var_num.varIndex = var_count;
                	 var_count ++;
                        break;
                case 2:
                	 if(flag == -1){
                	 	TextCode.add("\%t" + var_count + "  = load i8, i8* @" + $ID.text + ", align 1 ");
                	 }
                	 else{
                	 	TextCode.add("\%t" + var_count + " = load i8, i8* \%t" + vIndex + ", align 1 ");
                	 } 
                	 $theInfo.var_num.varIndex = var_count;
                	 var_count ++;
                        break;
                }
              }
	   | '(' arith_expression ')' { $theInfo = $arith_expression.theInfo; };
	   
printf_stmt: PRINTF '(' STRING_LITERAL ')'
	{
		int len = ($STRING_LITERAL.text).length() - 1;
		
		String str = $STRING_LITERAL.text;
		str = str.substring(0, str.length()-1);
		
		if(str.contains("\\n")){
			len = len - 1;
			str = str.substring(0, str.length()-1);
			str = str + "0A";
		}
		str = str + "\\00" + "\"";
		TextCode.add(print_num, "@.str."+ string_num +" = private unnamed_addr constant [" + len + " x i8] c" + str + ", align 1");
		print_num ++;
		
		TextCode.add("\%t" + var_count + " = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([" + len + " x i8], [" + len + " x i8]* @.str." + string_num + ", i64 0, i64 0))");
		string_num ++;
		var_count ++;	
	}
	| PRINTF '(' STRING_LITERAL ',' ID ')'
	  {
	  	int len = ($STRING_LITERAL.text).length() - 1;
		
		String str = $STRING_LITERAL.text;
		str = str.substring(0, str.length()-1);
		
		if(str.contains("\\n")){
			len = len - 1;
			str = str.substring(0, str.length()-1);
			str = str + "0A";
		}
		
		str = str + "\\00" + "\"";
		TextCode.add(print_num, "@.str."+ string_num +" = private unnamed_addr constant [" + len + " x i8] c" + str + ", align 1");
		print_num ++;
	  
	  	Info temp = symtab.get($ID.text);
	  	TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp.var_num.varIndex + ", align 4");
	  	var_count ++;
	  	TextCode.add("\%t" + var_count + " = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([" + len + " x i8], [" + len + " x i8]* @.str."+ string_num +", i64 0, i64 0), i32 \%t" + (var_count-1) + ')');
		var_count ++;
		string_num ++;	

	  }
	| PRINTF '(' STRING_LITERAL ',' a = ID ',' b = ID ')'
	  {
	  
	  	int len = ($STRING_LITERAL.text).length() - 1;
		
		String str = $STRING_LITERAL.text;
		str = str.substring(0, str.length()-1);
		
		if(str.contains("\\n")){
			len = len - 1;
			str = str.substring(0, str.length()-1);
			str = str + "0A";
		}
		
		str = str + "\\00" + "\"";
		TextCode.add(print_num, "@.str."+ string_num +" = private unnamed_addr constant [" + len + " x i8] c" + str + ", align 1");
		print_num ++;
	  
	  	Info temp = symtab.get($a.text);
	  	Info temp_1 = symtab.get($b.text);
	  	TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp.var_num.varIndex + ", align 4");
	  	var_count ++;
	  	TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp_1.var_num.varIndex + ", align 4");
	  	var_count ++;
	  	
	  	TextCode.add("\%t" + var_count + " = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([" + len + " x i8], [" + len + " x i8]* @.str."+ string_num +", i64 0, i64 0), i32 \%t" + (var_count-2) + ", i32 \%t" + (var_count-1) + ')');
		var_count ++;
		string_num ++;	
	  
	  
	  };
	  
if_else_stmt returns[int if_flag, int size]:IF '(' condition_judge {$size = $condition_judge.size;} ')' '{' if_branch'}' if_else_stmt_1{$if_flag = $if_else_stmt_1.if_flag;};

if_else_stmt_1 returns[int if_flag]:({$if_flag = 0;}| ELSE '{' else_branch '}'{$if_flag = 1;});
	   

if_branch:
{	TextCode.add("\nLtrue" + Ltrue_count + ":");
	Ltrue_count ++;
} statements
{
	TextCode.add("br label \%Lend" + Lend_count);
};

else_branch:
{	TextCode.add("\nLfalse" + Lfalse_count + ":");
	Lfalse_count ++;	
} statements
{
	TextCode.add("br label \%Lend" + Lend_count);
};
 
condition_judge returns[int size]: ID all_op DEC_NUM
		{
			Info temp = symtab.get($ID.text);
			if(temp.var_num.varIndex == -1){
				TextCode.add("\%t" + var_count + " = load i32, i32* @" + $ID.text + ", align 1 ");
			}
			else{
				TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp.var_num.varIndex + ", align 4");
			}
			
			if($all_op.attr == 0){
				TextCode.add("\%cond"+ cond_num +" = icmp eq i32 \%t" + var_count + ", " + $DEC_NUM.text);
			}
			else if($all_op.attr == 1){
				TextCode.add("\%cond"+ cond_num +" = icmp ne i32 \%t" + var_count + ", " + $DEC_NUM.text);
			}
			else if($all_op.attr == 2){
				TextCode.add("\%cond"+ cond_num +" = icmp sgt i32 \%t" + var_count + ", " + $DEC_NUM.text);
			}
			else if($all_op.attr == 3){
				TextCode.add("\%cond"+ cond_num +" = icmp sge i32 \%t" + var_count +  ", " + $DEC_NUM.text);
			}
			else if($all_op.attr == 4){
				TextCode.add("\%cond"+ cond_num +" = icmp slt i32 \%t" + var_count + ", " + $DEC_NUM.text);
			}
			else if($all_op.attr == 5){
				TextCode.add("\%cond"+ cond_num +" = icmp sle i32 \%t" + var_count + ", " + $DEC_NUM.text);
			}
			var_count ++;
			TextCode.add("br i1 \%cond"+ cond_num +", label \%Ltrue" + Ltrue_count + ", label \%Lfalse" + Lfalse_count);
			$size = TextCode.size(); 
		}
		| DEC_NUM all_op ID
		{	
			Info temp = symtab.get($ID.text);
			if(temp.var_num.varIndex == -1){
				TextCode.add("\%t" + var_count + " = load i32, i32* @" + $ID.text + ", align 1 ");
			}
			else{
				TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp.var_num.varIndex + ", align 4");
			}
			if($all_op.attr == 0){
				TextCode.add("\%cond"+ cond_num +" = icmp eq i32 " + $DEC_NUM.text + ", \%t" + var_count);
			}
			else if($all_op.attr == 1){
				TextCode.add("\%cond"+ cond_num +" = icmp ne i32 " + $DEC_NUM.text + ", \%t" + var_count);
			}
			else if($all_op.attr == 2){
				TextCode.add("\%cond"+ cond_num +" = icmp sgt i32 " + $DEC_NUM.text + ", \%t" + var_count);
			}
			else if($all_op.attr == 3){
				TextCode.add("\%cond"+ cond_num +" = icmp sge i32 " + $DEC_NUM.text + ", \%t" + var_count);
			}
			else if($all_op.attr == 4){
				TextCode.add("\%cond"+ cond_num +" = icmp slt i32 " + $DEC_NUM.text + ", \%t" + var_count);
			}
			else if($all_op.attr == 5){
				TextCode.add("\%cond"+ cond_num +" = icmp sle i32 " + $DEC_NUM.text + ", \%t" + var_count);
			}
			var_count ++;
			TextCode.add("br i1 \%cond"+ cond_num +", label \%Ltrue" + Ltrue_count + ", label \%Lfalse" + Lfalse_count);
			$size = TextCode.size(); 
		};
/*
		| DEC_NUM all_op DEC_NUM
		{			
			if($all_op.attr == 0){
				TextCode.add("\%cond = icmp eq i32 " + $DEC_NUM.text + ", " + $DEC_NUM);
			}
			else if($all_op.attr == 1){
				TextCode.add("\%cond = icmp ne i32 " + $DEC_NUM.text + ", " + $DEC_NUM);
			}
			else if($all_op.attr == 2){
				TextCode.add("\%cond = icmp sgt i32 " + $DEC_NUM.text + ", " + $DEC_NUM);
			}
			else if($all_op.attr == 3){
				TextCode.add("\%cond = icmp sge i32 " + $DEC_NUM.text + ", " + $DEC_NUM);
			}
			else if($all_op.attr == 4){
				TextCode.add("\%cond = icmp slt i32 " + $DEC_NUM.text + ", " + $DEC_NUM);
			}
			else if($all_op.attr == 5){
				TextCode.add("\%cond = icmp sle i32 " + $DEC_NUM.text + ", " + $DEC_NUM);
			}
			var_count ++;
			TextCode.add("br i1 \%cond, label \%Ltrue" + Ltrue_count + ", label \%Lfalse" + Lfalse_count);		
		};
		
*/

all_op returns [int attr]
    : EQ_OP {  $attr = 0; }
    | NE_OP {  $attr = 1; }
    | GT_OP {  $attr = 2; }
    | GE_OP {  $attr = 3; }
    | LT_OP {  $attr = 4; }
    | LE_OP {  $attr = 5; }
    ; 
    
all_op_1 returns [int attr]:
	PP_OP {$attr = 0; }
       |MM_OP {$attr = 1; }
       ;      

scanf_stmt: SCANF '(' STRING_LITERAL ',' '&' ID ')'{
		
		int len = ($STRING_LITERAL.text).length() - 1;
		String str = $STRING_LITERAL.text;
		str = str.substring(0, str.length()-1);
		
		str = str + "\\00" + "\"";
		TextCode.add(print_num, "@.str."+ string_num +" = private unnamed_addr constant [" + len + " x i8] c" + str + ", align 1");
		print_num ++;
	  
	  	Info temp = symtab.get($ID.text);
	  	TextCode.add("\%t" + var_count + " = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([" + len + " x i8], [" + len + " x i8]* @.str."+ string_num +", i64 0, i64 0), i32* \%t" + (var_count - 1) + ')');
		var_count ++;
		string_num ++;	
	
};

while_stmt: WHILE{
		int temp = Jump_num;
		Jump_num ++;
		TextCode.add("br label \%Jump" + temp);
		TextCode.add("\nJump" + temp + ":");
} 
'(' condition_judge ')' '{' while_ '}' {
		TextCode.add("br label \%Jump" + temp);
		TextCode.add("\nLfalse" + Lfalse_count + ":");	
};

while_:{
	TextCode.add("\nLtrue" + Ltrue_count + ":");
	Ltrue_count ++;
} statements;

switch_stmt: SWITCH '(' ID ')' '{' 

	{
		Info temp = symtab.get($ID.text);
		
		TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp.var_num.varIndex + ", align 4");
		var_count ++;
	
		int size = TextCode.size();	
	}
		CASE a = DEC_NUM ':' 
		{
			TextCode.add("\nJump" + Jump_num + ":");
		}
		statements BREAK ';'
		{
			TextCode.add("br label \%Jump" + (Jump_num+3));
		}
		CASE b = DEC_NUM ':'
		{
			TextCode.add("\nJump" + (Jump_num+1) + ":");
		}
		statements BREAK ';'
		{
			TextCode.add("br label \%Jump" + (Jump_num+3));
		}
		CASE c = DEC_NUM ':' 
		{
			TextCode.add("\nJump" + (Jump_num+2) + ":");
		}
		statements BREAK ';'
		{
			TextCode.add("br label \%Jump" + (Jump_num+3));
		}
	     '}'
	     {
	     	TextCode.add("\nJump" + (Jump_num+3) + ":");
	     }
	{
		TextCode.add(size, "switch i32 \%t" + (var_count-1) + ", label \%Jump" + (Jump_num+3) + " [");
		TextCode.add((size+1), "   i32 " + $a.text + ", label \%Jump" + Jump_num);
		TextCode.add((size+2), "   i32 " + $b.text + ", label \%Jump" + (Jump_num+1));
		TextCode.add((size+3), "   i32 " + $c.text + ", label \%Jump" + (Jump_num+2));
		TextCode.add((size+4), "]");
		Jump_num += 4;
	};
	
for_stmt: FOR '(' a = ID '=' b = DEC_NUM ';' 
	   {
	   	Info temp = symtab.get($a.text);
		TextCode.add("store i32 " + $b.text + ", i32* \%t" + temp.var_num.varIndex + ", align 4");
		TextCode.add("br label \%Jump" + Jump_num);
		TextCode.add("\nJump" + Jump_num + ":");
	   }
	   
	   condition_judge';'
	  {
	  	TextCode.add("\nLtrue" + Ltrue_count + ":");
	  } 
	  c = ID all_op_1 ')' '{' statements '}' 
	  {
	  	TextCode.add("br label \%Jump" + (Jump_num+1));	
	  	TextCode.add("\nJump" + (Jump_num+1) + ":");
	  	
	  	Info temp_1 = symtab.get($c.text);
	  		TextCode.add("\%t" + var_count + " = load i32, i32* \%t" + temp_1.var_num.varIndex + ", align 4 ");
	  		var_count ++;
	  	
	  	if($all_op_1.attr == 0){
	  		TextCode.add("\%t" + var_count + " = add nsw i32 \%t" + (var_count-1) + ", 1 ");	
	  	}
	  	else{
	  		TextCode.add("\%t" + var_count + " = sub nsw i32 \%t" + (var_count-1) + ", 1 ");	  		
	  	}
	
	  		var_count ++;
	  		TextCode.add("store i32 \%t" + (var_count-1) + ", i32* \%t" + temp_1.var_num.varIndex + ", align 4");
	  		TextCode.add("br label \%Jump" + Jump_num);
	
	  	TextCode.add("\nLfalse" + Lfalse_count + ':');
	  	Ltrue_count ++;
	  	Lfalse_count ++;
	  	Jump_num = Jump_num + 2;	
	  
	  }
	  
	  ;
 
 
          
/*--------------------------*/
/*	Reserved word	     */
/*--------------------------*/
RETURN:'return';
/*--------------------------*/
/*	  Data Type	     */
/*--------------------------*/
INT:'int';
CHAR:'char';
FLOAT:'float';
STRUCT:'struct';
VOID: 'void';
/*--------------------------*/
/*	  Operators	     */
/*--------------------------*/
LT_OP:'<';
GT_OP:'>';
LE_OP:'<=';
GE_OP:'>=';
EQ_OP:'==';
NE_OP:'!=';
PLUS_OP:'+';
MINUS_OP:'-';
MULTIPLE_OP:'*';
DIVID_OP:'/';
PP_OP: '++';
MM_OP: '--';
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
STRING_LITERAL:  '"' ( EscapeSequence | ~('\\'|'"') )* '"';
/*--------------------------*/
/*        Blank 	     */
/*--------------------------*/
NULL: 'null'| '\\0'{$channel=HIDDEN;};
WS: (' '|'\r'|'\t'|'\n')+ {$channel=HIDDEN;};
COMMENT:'/*' .* '*/' {$channel=HIDDEN;};
fragment EscapeSequence: '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\');
