#ifndef _TRANSLATE_H
#define _TRANSLATE_H

#include <bits/stdc++.h>

extern  char* yytext;
extern  int yyparse();

using namespace std;

class SymTab;   // first the symbol table class   
class Sym;      // then the symbol table entry class 

// since each symbol table entry has a type which may be not be primtive types like int,
// we need to define a type class
class SymType;       

extern SymTab* currST;       // Pointer to the current Symbol Table 
extern SymTab* globalST;     // The global Symbol Table

extern stack<string> var_type;  // type in the latest declaration
extern SymTab* currST_Ptr;      // pointer to the latest symtable of a function definition

class Quad;                             // stands for a single entry in the quad Array
extern vector<Quad> QuadArray;          // the quad Array
void print_QuadArray();                 // Function to print the quad array

// Flags to be used in symbol table operations
#define FIND 4
#define INSERT 2

/*
 * Class defination for Symbol Table
*/
class SymTab 
{                                        
public:
  string name;                           // Name of the Table
  SymType* retType;                      // Return type of the function
  vector<Sym> params;                   // Parameters of the function
  int count;                             // Count of the temporary variables
  SymTab* parent;                        // Parent ST of the current ST

  // the table is implemented as a map from the name of the symbol to the symbol table entry
  std::map<string,Sym> table;    // having RBT makes it efficient to search for a symbol   

  std::map<string,int> ar;       // activation record
  
  SymTab (string name="NULL");           // Constructor

  // A method to lookup an id (given its name or lexeme) in the Symbol Table. If
  // the id exists, the entry is returned, otherwise a new entry is created
  Sym* lookup (string, int flags = FIND|INSERT);      

  // A method to update different fields of an existing entry
  void update_offsets();           

  // A method to print the Symbol Table in a suitable format. This is needed for debugging
  void print();          
};

/*
 * Class defination for Symbol Table Entry
*/
class Sym { 
public:
  string name;                            // name of the symbol
  SymType *type;                          // type of the symbol
  string init_val;                        // initial value of the symbol if specified
  int size;                               // the size of the symbol
  int offset;                             // the offset of symbol in ST
  SymTab* nested;                         // points to the nested symbol table

  string category;                        // category of the symbol (global, local or param)
    
  // constructor
  Sym();
  Sym (string , string t="int", SymType* ptr = NULL, int width = 0);  

  // updates the type and size of the symbol based on the symbol type specified
  Sym* update(SymType*);   
};

/*
 * Class definition of Symbol Type 
*/
class SymType 
{                                        
public:
  string type;                            // stores the type of symbol. 
  int width;                              // stores the size of Array (if we encounter an Array) and it is 1 in default case
  SymType* arrtype;                       // stores the array type if 
  
  SymType(string , SymType* ptr = NULL, int width = 1);  //Constructor
};


/*
 * Class definition of Quad
*/
class Quad 
{                         
public:
  string res;                              // Result
  string op;                               // Operator
  string arg1;                             // Argument 1
  string arg2;                             // Argument 2    

  // functions to print a quad
  void print_Quad();	void type1(); void type2();   

  Quad (string , string , string op = "=", string arg2 = "");			
};

/*
 * Class definition of Expression
*/
class Expression {
public:
  Sym* loc;         // pointer to the symbol table entry of the expression                
  bool isBoolean;

  // if is array, store the array head separately
  Sym* Array;
  bool isArray;
  bool isPtr;

  // if the type is "bool" then we maintain truelist and falselist -
  // indicative of locations of goto instructions (separated into true/false) 
  // associated with the boolean exp.
  list<int> truelist;  
  list<int> falselist;    

  // else we just maintain a nextlist - indicative of locations of all goto instructions
  list<int> nextlist;                                         

  Expression();
};

/*
 * Class definition of Statement
*/
class Statement {
public:
  // nextlist for Statement with dangling exit
  list<int> nextlist;           
};

/*
 * Emit: A static method to add a (newly generated) quad.
*/
void emit(string , string , string arg1="" , string arg2="" );
void emit(string , string , int , string arg2="" );

/*
 * gentemp: generate a temp variable and insert it in the symbol table
*/
Sym* gentemp (SymType* type , string init_val = "-");


// backpatch the dangling instructions with the given address(parameter) 
void backpatch (list <int> , int );                
// Make a new list contanining an integer address
list<int> makelist (int );
// Merge two lists into a single list
list<int> merge (list<int> &l1, list <int> &l2); 


// helper function to convert int <-> bool
Expression* convertIntToBool(Expression*);
Expression* convertBoolToInt(Expression*); 

Sym* convertType(Sym*, string);                           // helper function for type conversion
int computeSize (SymType *);                              // helper function to calculate size of symbol type
bool typecheck(Sym* &s1, Sym* &s2);               // helper function to check for same type of two symbol table entries
bool compareSymbolType(SymType*, SymType*);               // helper function to check for same type of two symboltype objects

int nextinstr();                                          // Returns the next instruction number

string printType(SymType *);                              // print type of symbol

#endif