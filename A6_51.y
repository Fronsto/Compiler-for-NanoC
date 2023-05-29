%{
  #include <bits/stdc++.h>
  #include <sstream>
  #include "A6_51_translator.h"

  extern int yylex();
  void yyerror(string);
  extern stack<string> var_type;
  using namespace std;

	vector<string> allstrings;
%}

%union {
    char unary_op;                                           // unaryoperator		
    char* char_val;                                          // char value
    int instr_number;                                        // instruction number: for backpatching
    int int_val;                                             // integer value	
    int num_params;                                          // number of parameters
    Expression* expr;                                        // expression
    Statement* stat;                                         // statement		
    SymType* sym_type;                                      // symbol type  
    Sym* sym_ptr;                                            // symbol
}

%token CHAR ELSE FOR IF INT RETURN VOID

%token <sym_ptr> IDENTIFIER
%token <int_val> INT_CONSTANT
%token <char_val> STRING_LITERAL
%token <char_val> CHAR_CONSTANT

%token INVALID_TOKEN

%token ARROW AMPERSAND ASTERISK PLUS MINUS DIVISION MODULO EXCLAMATION LESS_THAN GREATER_THAN LESS_THAN_EQUAL GREATER_THAN_EQUAL EQUAL NOT_EQUAL AND OR 

// to handle shift-reduce conflicts of else and if
%nonassoc ')'
%nonassoc ELSE

//unary operator
%type <unary_op> unary_operator

//number of parameters
%type <num_params> argument_expression_list argument_expression_list_opt


//Expressions
%type <expr>
	expression
	primary_expression 
	postfix_expression
	unary_expression
	multiplicative_expression
	additive_expression
	relational_expression
	equality_expression
	logical_and_expression
	logical_or_expression
	conditional_expression
	assignment_expression
	expression_statement

//Statements
%type <stat>  statement
	compound_statement
	selection_statement
	iteration_statement
	jump_statement
	block_item
	block_item_list
	block_item_list_opt

//symbol
%type <sym_ptr> initializer
%type <sym_ptr> direct_declarator init_declarator declarator

//Auxillary non-terminals next_instr_addr and augmented_goto
%type <instr_number> next_instr_addr
%type <stat> augmented_goto

%start translation_units

%%

/* 
* For backpatching, which inserts a goto 
* and stores the index of the next goto 
* statement to guard against fallthrough

* augmented_goto->nextlist = makelist(nextinstr) we have defined nextlist for Statements
*/
augmented_goto: /* empty*/ {
		$$ = new Statement();
		$$->nextlist=makelist(nextinstr());
		emit("goto","");
	}
  ;

/*
* backpatching,stores the index of the next quad to be generated
* Used in various control statements
*/
next_instr_addr: /*empty*/ {
		$$ = nextinstr();
	}   
	;

/*
 * changes currST and emit label for this.
 * Since we only have function scopes, 
 * this is called only in function declaration and definition
 * and there the currST_Ptr already points to the function name entry
 * (present in the global symbol table)
 */
create_table: /*empty*/ {
		currST = new SymTab("");
		currST->parent = globalST;
	}
	;
change_table: /*empty*/ 
	{
		currST = currST_Ptr;						     
		emit("Function", currST->name);
	}
	;

/* 1. Expressions      */
/***********************/

primary_expression: IDENTIFIER
	{
	    $$=new Expression();                                                  // create new expression and store pointer to ST entry in the location			
	    $$->loc=$1;
			$$->isBoolean = false;
	}
	| INT_CONSTANT
	{ 
		$$=new Expression();	
		string p=to_string($1);
		$$->loc=gentemp(new SymType("int"),p);
		emit("=",$$->loc->name,p);
	}
	| CHAR_CONSTANT       	  			
	{                                                                         // create new expression and store the value of the constant in a temporary
		$$=new Expression();
		$$->loc=gentemp(new SymType("char"),$1);
		emit("=",$$->loc->name,string($1));
	}
	| STRING_LITERAL        					    
	{                                                                          // create new expression and store the value of the constant in a temporary
		$$=new Expression();
		$$->loc=gentemp(new SymType("ptr"),$1);
		$$->loc->type->arrtype=new SymType("char");
		allstrings.push_back($1);

		emit("=str", $$->loc->name, to_string(allstrings.size()-1));
	}
	| '(' expression ')'
	{                                                                          // simply equal to expression
		$$=$2;
	}
  ;

postfix_expression: primary_expression      				       //create new Array and store the location of primary expression in it
	{
		$$ = $1; 
		$$->Array=$$->loc;                        // copy the base
	}
	| primary_expression '[' expression ']' 
	{ 	
		$$=new Expression();
		$$->Array=$1->loc;                        // copy the base
		// $$->loc=gentemp(new SymType("int"));     // store computed address
		$$->loc = $3->loc;
		$$->isArray = true;

		// int p=computeSize($1->loc->type->arrtype);	
		// emit("*",$$->loc->name,$3->loc->name,to_string(p));
	}
	| primary_expression '(' argument_expression_list_opt ')'       
	{
		$$=new Expression();
		if($1->loc->nested==NULL)
		{
			string error_msg = "Function not defined: " + $1->loc->name;
			yyerror(error_msg);
		}
		$$->loc=gentemp($1->loc->nested->retType);
		$$->Array=$$->loc;                        // copy the base
		emit("call",$$->loc->name,$1->loc->name,to_string($3));
	}
	;

argument_expression_list_opt: 
  argument_expression_list 
	{ 
		$$=$1; // Equate $$ and $1
	}
	| /* empty */
	{ 
		$$=0; // No arguments
	} 
	;
argument_expression_list: 
  argument_expression_list ',' assignment_expression     
	{
		$$=$1+1;                                  //one more argument and emit param		 
		emit("param",$3->loc->name);
	}
  |
  assignment_expression    
	{
		$$=1;                                      //one argument and emit param
		emit("param",$1->loc->name);	
	}
	;

unary_expression: postfix_expression { $$=$1; /*Equate $$ and $1*/} 					  
  | unary_operator postfix_expression {
		$$ = new Expression();
		switch($1)
		{	  
			case '&':                                                  //address of something, then generate a pointer temporary and emit the quad
				$$->Array=gentemp(new SymType("ptr"));
				$$->Array->type->arrtype=$2->Array->type; 
				emit("=&",$$->Array->name,$2->Array->name);
				break;
			case '*':                                                   // value of something, then generate a temporary of the corresponding type and emit the quad	
				$$->isPtr = true;
				$$->loc=gentemp($2->Array->type->arrtype);
				$$->Array=$2->Array;
				emit("=*",$$->loc->name,$2->Array->name);
				break;
			case '+':  
				$$=$2;
				break;                 //unary plus, do nothing
			case '-':				   //unary minus, generate new temporary of the same base type and make it negative of current one
				$$->Array=gentemp(new SymType($2->Array->type->type));
				emit("uminus",$$->Array->name,$2->Array->name);
				break;
			case '!':				//logical not, generate new temporary of the same base type and make it negative of current one
				if($2->isBoolean)
				{
					// just flip the truelist and falselist
					$$->isBoolean = true;
					$$->truelist = $2->falselist;
					$$->falselist = $2->truelist;
					$$->loc = $2->loc;
					$$->Array = $2->Array;
				}
				else
				{
					string error_msg = "Logical not operator can only be applied to boolean expressions";
					yyerror(error_msg);
				}
				break;
		}
  }
  ;
unary_operator:
  AMPERSAND { $$ = '&';}
  | ASTERISK { $$ = '*';}
  | PLUS { $$ = '+';}
  | MINUS { $$ = '-';}
  | EXCLAMATION { $$ = '!';}
  ;

multiplicative_expression: // left assoc
  unary_expression {
		$$ = new Expression();             //generate new expression							    
		if($1->isArray) 			   //if it is of type arr
		{
			$$->loc = gentemp($1->loc->type);	
			emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);     //emit with Array right
			$1->isArray = false;
		}
		else if($1->isPtr)         //if it is of type ptr
		{ 
			$$->loc = $1->loc;        //equate the locs
		}
		else
		{
			$$ = $1;
			$$->loc = $1->Array;
			// $$->truelist = $1->truelist;
		}
  }
  | multiplicative_expression ASTERISK unary_expression {
		//if we have multiplication
		if(!typecheck($1->loc, $3->Array))         
			yyerror("Type Error in Program");
		else 								 //if types are compatible, generate new temporary and equate to the product
		{
			$$ = new Expression();	
			$$->loc = gentemp(new SymType($1->loc->type->type));
			emit("*", $$->loc->name, $1->loc->name, $3->Array->name);
		}
  }
  | multiplicative_expression DIVISION unary_expression {
		//if we have division
		if(!typecheck($1->loc, $3->Array)){ 
			yyerror("Type Error in Program");
		}
		else   
		{
			//if types are compatible, generate new temporary and equate to the quotient
			$$ = new Expression();
			$$->loc = gentemp(new SymType($1->loc->type->type));
			emit("/", $$->loc->name, $1->loc->name, $3->Array->name);
		}
  }
  | multiplicative_expression MODULO unary_expression {
		if(!typecheck($1->loc, $3->Array))
			yyerror("Type Error in Program");
		else 		 
		{
			//if types are compatible, generate new temporary and equate to the quotient
			$$ = new Expression();
			$$->loc = gentemp(new SymType($1->loc->type->type));
			emit("%", $$->loc->name, $1->loc->name, $3->Array->name);	
		}
  }
	;
additive_expression: // left assoc
  multiplicative_expression { 
    $$=$1; 
  }
  | additive_expression PLUS multiplicative_expression {
		
		if(!typecheck($1->loc, $3->loc))
			yyerror("Type Error in Program");
		else    	//if types are compatible, generate new temporary and equate to the sum
		{
			$$ = new Expression();	
			$$->loc = gentemp(new SymType($1->loc->type->type));
			emit("+", $$->loc->name, $1->loc->name, $3->loc->name);
		}

  }
  | additive_expression MINUS multiplicative_expression {
		if(!typecheck($1->loc, $3->loc))
			cout << "Type Error in Program"<< endl;		
		else        //if types are compatible, generate new temporary and equate to the difference
		{	
			$$ = new Expression();	
			$$->loc = gentemp(new SymType($1->loc->type->type));
			emit("-", $$->loc->name, $1->loc->name, $3->loc->name);
		}

  }
  ;

relational_expression: // left assoc
  additive_expression {
    $$=$1;
  }
  | relational_expression LESS_THAN additive_expression {
		if(!typecheck($1->loc, $3->loc)) 
		{
			yyerror("Type Error in Program");
		}
		else 
		{      //check compatible types									
			$$ = new Expression();
			$$->loc = $1->loc;                      //loc is the same as the first expression
			$$->isBoolean = true;
			$$->truelist = makelist(nextinstr());     //makelist for truelist and falselist
			$$->falselist = makelist(nextinstr()+1);
			emit("<", "", $1->loc->name, $3->loc->name);     //emit statement if a<b goto .. 
			emit("goto", "");	//emit statement goto ..
		}
  }
  | relational_expression GREATER_THAN additive_expression {
		// similar to above, check compatible types,make new lists and emit
		if(!typecheck($1->loc, $3->loc)) 
		{
			yyerror("Type Error in Program");
		}
		else 
		{	
			$$ = new Expression();		
			$$->loc = $1->loc;                      //loc is the same as the first expression
			$$->isBoolean = true;
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit(">", "", $1->loc->name, $3->loc->name);
			emit("goto", "");
		}	
  }
  | relational_expression LESS_THAN_EQUAL additive_expression {
		if(!typecheck($1->loc, $3->loc)) 
		{
			cout << "Type Error in Program"<< endl;
		}
		else 
		{			
			$$ = new Expression();		
			$$->loc = $1->loc;                      //loc is the same as the first expression
			$$->isBoolean = true;
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit("<=", "", $1->loc->name, $3->loc->name);
			emit("goto", "");
		}		

  }
  | relational_expression GREATER_THAN_EQUAL additive_expression {
		if(!typecheck($1->loc, $3->loc))
		{
			cout << "Type Error in Program"<< endl;
		}
		else 
		{	
			$$ = new Expression();	
			$$->loc = $1->loc;                      //loc is the same as the first expression
			$$->isBoolean = true;
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit(">=", "", $1->loc->name, $3->loc->name);
			emit("goto", "");
		}

  }
  ;

equality_expression: // left assoc
  relational_expression {
    $$=$1;
  }
  | equality_expression EQUAL relational_expression {
		if(!typecheck($1->loc, $3->loc))                //check compatible types
		{
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			convertBoolToInt($1);                  //convert bool to int		
			convertBoolToInt($3);
			$$ = new Expression();
			$$->isBoolean = true;
			$$->loc = $1->loc;                      //loc is the same as the first expression
			$$->truelist = makelist(nextinstr());            //make lists for new expression
			$$->falselist = makelist(nextinstr()+1); 
			emit("==", "", $1->loc->name, $3->loc->name);      //emit if a==b goto ..
			emit("goto", "");				//emit goto ..
		}

  }
  | equality_expression NOT_EQUAL relational_expression {
		if(!typecheck($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{			
			convertBoolToInt($1);
			convertBoolToInt($3);
			$$ = new Expression();                 //result is boolean
			$$->isBoolean = true;
			$$->loc = $1->loc;                      //loc is the same as the first expression
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit("!=", "", $1->loc->name, $3->loc->name);
			emit("goto", "");
		}
  }
  ;

logical_and_expression: // left assoc
  equality_expression {
    $$=$1;
  }
  | logical_and_expression AND next_instr_addr equality_expression {
		convertIntToBool($4);                                  //convert inclusive_or_expression int to bool	
		convertIntToBool($1);                                  //convert logical_and_expression to bool
		$$ = new Expression();                                 //make new boolean expression 
		$$->loc = $1->loc;                      //loc is the same as the first expression
		$$->isBoolean = true;
		backpatch($1->truelist, $3);                           //if $1 is true, we move to $5
		$$->truelist = $4->truelist;                           //if $5 is also true, we get truelist for $$
		$$->falselist = merge($1->falselist, $4->falselist);   //merge their falselists

  }
  ;
logical_or_expression: // left assoc
  logical_and_expression {
    $$=$1;
  }
  | logical_or_expression OR next_instr_addr logical_and_expression {
		convertIntToBool($4);			 //convert logical_and_expression int to bool	
		convertIntToBool($1);			 //convert logical_or_expression to bool
		$$ = new Expression();			 //make new boolean expression
		$$->loc = $1->loc;                      //loc is the same as the first expression
		$$->isBoolean = true;
		backpatch($1->falselist, $3);		//if $1 is true, we move to $5
		$$->truelist = merge($1->truelist, $4->truelist);		//merge their truelists
		$$->falselist = $4->falselist;		 	//if $5 is also false, we get falselist for $$

  }
  ;
conditional_expression: // right assoc
  logical_or_expression {
    $$=$1;
  }
  | logical_or_expression augmented_goto '?' next_instr_addr expression augmented_goto ':' next_instr_addr conditional_expression {
		$$->loc = gentemp($5->loc->type);       //generate temporary for expression
		$$->loc->update($5->loc->type);
		emit("=", $$->loc->name, $9->loc->name);      //make it equal to sconditional_expression
		list<int> l = makelist(nextinstr());        //makelist next instruction
		emit("goto", "");              //prevent fallthrough
		backpatch($6->nextlist, nextinstr());        //after augmented_goto, go to next instruction
		emit("=", $$->loc->name, $5->loc->name);
		list<int> m = makelist(nextinstr());         //makelist next instruction
		l = merge(l, m);						//merge the two lists
		emit("goto", "");						//prevent fallthrough
		backpatch($2->nextlist, nextinstr());   //backpatching
		convertIntToBool($1);                   //convert expression to boolean
		backpatch($1->truelist, $4);           //$1 true goes to expression
		backpatch($1->falselist, $8);          //$1 false goes to conditional_expression
		backpatch(l, nextinstr());
  }
  ;
assignment_expression:
  conditional_expression {
    $$=$1;
  }
  | unary_expression '=' assignment_expression {
		if($1->isArray)          // if type is arr, simply check if we need to convert and emit
		{
			emit("[]=", $1->Array->name, $1->loc->name, $3->loc->name);		
		}
		else if($1->isPtr)     // if type is ptr, simply emit
		{
			emit("*=", $1->Array->name, $3->loc->name);	
		}
		else                              //otherwise assignment
		{
			emit("=", $1->Array->name, $3->loc->name);
		}
		
		$$ = $3;
  }
  ;

expression:
  assignment_expression {
    $$=$1;
  }
  ;


/* 2. Declaration      */ 
/***********************/ 
declaration:
  type_specifier init_declarator ';' {
		// if we just ended a function declaration, we need to reset the current symbol table pointer
		currST_Ptr = NULL; 
	}
  ;

init_declarator:
  declarator {
		// check if you're in globalST, if yes initialize to 0
		if(currST == globalST)
		{
			if($1->type->type == "int" || $1->type->type == "char" || $1->type->type == "ptr"|| $1->type->type == "arr"){
				$1->init_val = "0";
			}
		} 
	}
  | declarator '=' initializer {		
      if($3->init_val!="") $1->init_val=$3->init_val;        //get the initial value and  emit it
		  emit("=", $1->name, $3->name);	
    }
  ;

initializer:
  assignment_expression {$$=$1->loc;}
  ;

type_specifier:
  INT { var_type.push("int"); }
  | CHAR { var_type.push("char"); }
  | VOID { var_type.push("void"); }
  ;

declarator:
  ASTERISK direct_declarator {
    SymType *t = new SymType("ptr");
		if($2->nested!=NULL){
			// update the return type of this function
			t->arrtype = $2->nested->retType;
			$2->nested->retType = t;
			$$ = $2;
		} else {
			t->arrtype = $2->type;                // add the base type 
			$$ = $2->update(t);                   // $$ value will used for initialization
		}
  }
  | direct_declarator {
    $$ = $1;
  }
  ;
direct_declarator:
  IDENTIFIER {
		// insert the symbol (don't find) in the symbol table
		$1 = currST->lookup($1->name, INSERT);       
		// then update the type based on latest type specifier encountered
		$$ = $1->update(new SymType(var_type.top())); var_type.pop();
  }
  | IDENTIFIER '[' INT_CONSTANT ']' {
		$1 = currST->lookup($1->name, INSERT);        
		$1->update(new SymType(var_type.top())); var_type.pop();
    SymType* s = new SymType("arr", $1->type, $3 );  
    $$ = $1->update(s);   
  }
  | IDENTIFIER '(' create_table parameter_list_opt ')' {
		$1->update(new SymType("func"));
		$1->category = "func";
    currST->name = $1->name;

		if(var_type.top() !="void") {
			Sym *s = currST->lookup("retVal");         //lookup for return value	
			s->update(new SymType(var_type.top()));	 
			currST->retType = s->type;
		} else {
			currST->retType = new SymType("void");
		}
		var_type.pop();	

		$1->nested=currST;       
		currST_Ptr = currST;
		currST = globalST;				// Come back to globalsymbol table
		$$ = $1;
  }
  ;
parameter_list_opt:
  parameter_list
  | /* empty */
  ;
parameter_list:
  parameter_list ',' parameter_declaration {}
  | parameter_declaration { }
  ;
parameter_declaration:
  type_specifier ASTERISK IDENTIFIER
  {
    SymType *t = new SymType("ptr");
		t->arrtype = new SymType(var_type.top()); var_type.pop();  //add the base type 
		$3->category = "param";
		$3 = currST->lookup($3->name, INSERT);       
		$3->update(t);                  //update
		currST->params.push_back(*($3));   //add to the list of parameters
  }
  |
  type_specifier IDENTIFIER
  {
		$2 = currST->lookup($2->name, INSERT);   
		$2->category = "param";
    // update ID type by the var_type
    $2->update(new SymType(var_type.top())); var_type.pop();
		currST->params.push_back(*($2));   //add to the list of parameters
  }
  ;

/* 3. Statements       */ 
/***********************/ 
statement:
  compound_statement     { $$=$1; } /* nested block */
  | expression_statement { 
			$$=new Statement();              //create new statement with same nextlist
			$$->nextlist=$1->nextlist; 
	 	} /* expression   */
  | selection_statement  { $$=$1; } /* if else      */
  | iteration_statement  { $$=$1; } /* for loop     */
  | jump_statement       { $$=$1; } /* return       */
  ;
compound_statement:
  '{' block_item_list_opt '}' { $$=$2; }
  ;
block_item_list_opt:
  block_item_list { $$=$1;}
  | /* empty */ { $$ = new Statement();}
  ;
block_item_list:
  block_item {
    $$=$1;
  }
  | block_item_list next_instr_addr block_item {
    $$=$3;
    backpatch($1->nextlist, $2);    
  }
  ;
block_item:
  declaration {
    $$= new Statement();
  }
  | statement {
    $$=$1;
  }
  ;
expression_statement:
  expression ';' {
		$$=$1;
  }
  | ';' {
    $$ = new Expression();
  }
  ;
selection_statement:
 IF '(' expression augmented_goto ')' next_instr_addr statement augmented_goto       // if statement without else
	{
		backpatch($4->nextlist, nextinstr());        //nextlist of augmented_goto goes to nextinstr
		convertIntToBool($3);         //convert expression to bool
		$$ = new Statement();        //make new statement
		backpatch($3->truelist, $6);        //is expression is true, go to next_instr_addr i.e just before statement body
		list<int> temp = merge($3->falselist, $7->nextlist);   //merge falselist of expression, nextlist of statement and second augmented_goto
		$$->nextlist = merge($8->nextlist, temp);
	}
	| IF '(' expression augmented_goto ')' next_instr_addr statement augmented_goto ELSE next_instr_addr statement   //if statement with else
	{
		backpatch($4->nextlist, nextinstr());		//nextlist of augmented_goto goes to nextinstr
		convertIntToBool($3);        //convert expression to bool
		$$ = new Statement();       //make new statement
		backpatch($3->truelist, $6);    //when expression is true, go to M1 else go to M2
		backpatch($3->falselist, $10);
		list<int> temp = merge($7->nextlist, $8->nextlist);       //merge the nextlists of the statements and second augmented_goto
		$$->nextlist = merge($11->nextlist,temp);	
	}
iteration_statement:
	FOR '('  expression_statement next_instr_addr expression_statement next_instr_addr expression augmented_goto ')' next_instr_addr statement  
  {
    $$ = new Statement();		 //create new statement
		convertIntToBool($5);  //convert check expression to boolean
		backpatch($5->truelist, $10);	//if expression is true, go to M2
		backpatch($8->nextlist, $4);	//after augmented_goto, go back to M1
		backpatch($11->nextlist, $6);	//statement go back to expression
		string str=to_string($6);
		emit("goto", str);				//prevent fallthrough
		$$->nextlist = $5->falselist;	//move out if statement is false
  }
	|
	FOR '('  expression_statement next_instr_addr expression_statement next_instr_addr  augmented_goto ')' next_instr_addr statement  
  {
    $$ = new Statement();		 //create new statement
		convertIntToBool($5);  //convert check expression to boolean
		backpatch($5->truelist, $9);	//if expression is true, go to M2
		backpatch($7->nextlist, $4);	//after augmented_goto, go back to M1
		backpatch($10->nextlist, $6);	//statement go back to expression
		string str=to_string($6);
		emit("goto", str);				//prevent fallthrough
		$$->nextlist = $5->falselist;	//move out if statement is false
  }
  ;
jump_statement:
  RETURN expression ';'               
	{
		// check if the return type is same as the function type
		// get the function type from the symbol table
		if($2->loc->type->type != currST->retType->type)
		{
			string error_msg = "Return type mismatch. Function " + currST->name +" expected " + currST->retType->type + " but got " + $2->loc->type->type;
			yyerror(error_msg);
		}
		$$ = new Statement();	
		emit("return",$2->loc->name);               //emit return with the name of the return value
	}
	| RETURN ';' 
	{
		if("void" != currST->retType->type)
		{
			string error_msg = "Return type mismatch. Function " + currST->name +" expected " + currST->retType->type + " but got void";
			yyerror(error_msg);
		}
		$$ = new Statement();	
		emit("return","");                         //simply emit return
	}
  ;

/* 4. Translation Unit */ 
/***********************/ 

translation_units:  /* handling multiple functions in a file */
  translation_unit {}
  | translation_units translation_unit {}
  | INVALID_TOKEN { yyerrok; }
  ;

translation_unit:
    function_definition {}
  | declaration         {}
  ;

// the following grammar rule is augmented to add changetable, carries the semantic action to change the symbol table
function_definition:
  type_specifier declarator declaration_list_opt change_table compound_statement 
  {
    // after we're reduced this entire function definition, we need to go back to the global ST.
    currST_Ptr = NULL;
		emit("FunctionEnd", currST->name);
		currST = globalST;  
  }  
  ;

declaration_list_opt:
  declaration_list 
  | /* empty */
  ;

declaration_list:
    declaration_list declaration {}
  | declaration {}
  ;

%%

void 
yyerror(string s)
{
	std::cout << "ERROR: " << s << std::endl;
	exit(0);
}