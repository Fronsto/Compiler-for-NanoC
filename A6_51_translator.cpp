#include "A6_51_translator.h"
#include <bits/stdc++.h>
using namespace std;

extern int yyparse();

const unsigned int size_of_char = 1;
const unsigned int size_of_int = 4;
const unsigned int size_of_pointer = 4;

vector<Quad> QuadArray;

SymTab *currST;   // Pointer to the current Symbol Table
SymTab *globalST; // The global Symbol Table

stack<string> var_type; // type in the latest declaration
SymTab *currST_Ptr;     // Pointer to the IDENTIFIER in the latest declaration

extern vector<string> allstrings;

/*
 * Expression class constructor
 */
Expression::Expression()
{
  this->isArray = false;
  this->isPtr = false;
  this->isBoolean = false;
}

/*
 * Constructor for Symbol Table Entry class
 */
Sym::Sym(string name, string t, SymType *arrtype, int width)
{
  this->name = name;
  type = new SymType(t, arrtype, width); // Generate type of symbol
  size = computeSize(type);              // find the size from the type
  offset = 0;                            // put initial offset as 0
  init_val = "";                        // no initial value
  nested = NULL;                         // no nested table
}
Sym::Sym(){ } // default constructor

Sym *Sym::update(SymType *t)
{
  type = t;                    // Update the new type
  this->size = computeSize(t); // new size
  return this;                 // return the same variable
}

/*
 * Constructor for Symbol Type class
 */
SymType::SymType(string type, SymType *arrtype, int width) 
{
  this->arrtype = arrtype; // array type
  this->type = type;       // type of the symbol
  this->width = width;     // width of the symbol
}

/*
 * Constructor for Symbol Table class
 */
SymTab::SymTab(string name) // constructor for a symbol table
{
  this->name = name; // name of the symbol table
  count = 0;         // Put count of number of temporary variables as 0
}

/*
 * Lookup an symbol in the symbol table, whether it exists or not
 */
Sym *SymTab::lookup(string name, int flags)
{
  // if the symbol is in the current table, just return that
  // since even if the query is to insert, we don't want duplicates in the table
  if (table.count(name))
    return &table[name];

  // if the symbol is not in the current table, check if it is in the parent table
  if (this->parent && (flags & FIND))
  {
    Sym *ptr = this->parent->lookup(name, FIND);
    if (ptr)
      return ptr;
  }
  // else if the symbol is not in the current table and not in the parent table, check if the query is to insert
  if (flags & INSERT)
  {
    Sym *symbol = new Sym(name);
    table[name] = *symbol;
    return &table[name];
  }
  return nullptr;
}

/*
 * update: updates offsets
 * of all the symbols in the symbol table
 */
void SymTab::update_offsets()
{
  vector<SymTab *> funcTables;
  int offset = 0;
  for (auto &tb_entry : table)
  {
    Sym &sym = tb_entry.second;
    sym.offset = offset;
    offset += sym.size;
    if (sym.nested != NULL)
    {
      funcTables.push_back(sym.nested);
    }
  }
  for (auto &tb : funcTables)
  {
    tb->update_offsets();
  }
}

/*
 * print: prints the symbol table
 */
void SymTab::print() // print a symbol table
{
  vector<SymTab *> tb; // list of tables
  std::cout << setw(120) << setfill('-') << "-" << endl;

  std::cout << "Table Name: " << (*this).name;
  // print the retType
  if (this->retType != NULL)
  {
    std::cout << "  |  Return Type: " << printType(this->retType);
  }
  std::cout << endl;
  std::cout << setw(120) << setfill('-') << "-" << endl;
	std::cout << setfill(' ') << left << setw(25) << "Name";
	std::cout << left << setw(20) << "Type";
	std::cout << left << setw(30) << "Initial Value";
	std::cout << left << setw(15) << "Size";
	std::cout << left << setw(15) << "Offset";
	std::cout << left << setw(15) << "Category";
  std::cout << std::endl;
	std::cout << setw(120) << setfill('-') << "-" << setfill(' ') << endl;

  for (auto &tb_entry : table)
  {
    auto it = &tb_entry.second;

    std::cout << left << setw(25) << it->name; 

    std::cout << left << setw(20) << printType(it->type); 

    if (it->init_val == "" || it->init_val == "-")
      it->init_val = "undefined"; 
    if (it->nested != NULL)
      it->init_val = "not-applicable"; 
    std::cout << left << setw(30) << it->init_val; 

    std::cout << left << setw(15) << it->size; 

    std::cout << left << setw(15) << it->offset; 

    std::cout << it->category << std::endl;
    if (it->nested != NULL)
      tb.push_back(it->nested); 
  }

	std::cout << setw(120) << setfill('-') << "-" << setfill(' ') << endl;
  std::cout << endl;
  for (auto &it : tb)
  {
    it->print();
  }
}

/*
 * Quad class constructor
 */
Quad::Quad(string res, string arg1, string op, string arg2)
{
  // res = arg1 op arg2
  this->op = op;
  this->arg1 = arg1;
  this->arg2 = arg2;
  this->res = res;
}

/*
 * print_Quad: prints the quadruple
 */
void Quad::print_Quad()
{
  ///////////////////////////////////////
  //          ARITHMETIC OPERATORS         //
  ///////////////////////////////////////

  if (op == "+")
    (*this).type1();
  else if (op == "-")
    (*this).type1();
  else if (op == "*")
    (*this).type1();
  else if (op == "/")
    (*this).type1();
  else if (op == "%")
    (*this).type1();

  ///////////////////////////////////////
  //       relational operators        //
  ///////////////////////////////////////

  else if (op == "==")
    (*this).type2();
  else if (op == "!=")
    (*this).type2();
  else if (op == "<=")
    (*this).type2();
  else if (op == "<")
    (*this).type2();
  else if (op == ">")
    (*this).type2();
  else if (op == ">=")
    (*this).type2();
  else if (op == "goto")
    std::cout << "goto " << res;

  ///////////////////////////////////////
  //       Assignment operators        //
  ///////////////////////////////////////
  else if (op == "=" || op=="=str")
    std::cout << res << " = " << arg1;

  else if (op == "=&")
    std::cout << res << " = &" << arg1;
  else if (op == "=*")
    std::cout << res << " = *" << arg1;
  else if (op == "*=")
    std::cout << "*" << res << " = " << arg1;

  else if (op == "uminus")
    std::cout << res << " = -" << arg1;
  // neg rax ; rax = - rax

  else if (op == "=[]")
    std::cout << res << " = " << arg1 << "[" << arg2 << "]";
  else if (op == "[]=")
    std::cout << res << "[" << arg1 << "]"
              << " = " << arg2;

  ///////////////////////////////////////
  //         other operators           //
  ///////////////////////////////////////

  else if (op == "return")
    std::cout << "return " << res;
  else if (op == "param")
    std::cout << "param " << res;
  else if (op == "call")
    std::cout << res << " = "
              << "call " << arg1 << ", " << arg2;
  else if (op == "Function")
    std::cout << res << ": ";
  else ; // ignore
  std::cout << std::endl;
}

void Quad::type1() // Printing binary operators
{
  std::cout << res << " = " << arg1 << " " << op << " " << arg2;
}

void Quad::type2() // Printing relation operators and jumps
{
  std::cout << "if " << arg1 << " " << op << " " << arg2 << " goto " << res;
}

/*
 * Print the QuadArray
 */
void print_QuadArray() 
{
	std::cout << setw(120) << setfill('-') << "-" << setfill(' ') << endl;
  std::cout << "THREE ADDRESS CODE (TAC): " << std::endl;
	std::cout << setw(120) << setfill('-') << "-" << setfill(' ') << endl;

  int j = 0;
  auto it = QuadArray.begin();
  while (it != QuadArray.end())
  {
    if (it->op == "label") // print the label if it is the operator
    {
      std::cout << std::endl
                << j << ": ";
      it->print_Quad();
    }
    else
    { // otherwise give 4 spaces and then print
      std::cout << j << ": \t";
      it->print_Quad();
    }
    it++;
    j++;
  }
	std::cout << setw(120) << setfill('-') << "-" << setfill(' ') << endl;
}

/*
 * Emit: A static method to add a (newly generated) quad.
 */
void emit(string op, string res, string arg1, string arg2)
{
  Quad *q = new Quad(res, arg1, op, arg2);
  QuadArray.push_back(*q);
}
void emit(string op, string res, int arg1, string arg2)
{
  Quad *q = new Quad(res, to_string(arg1), op, arg2);
  QuadArray.push_back(*q);
}

/*
 * GENTEMP
 * A static method to generate a new temporary, insert it to the Symbol Table,
 * and return a pointer to the entry
 */
Sym *gentemp(SymType *type, string init_val)
{                                                     // generate temp variable
  string tmp_name = "t" + to_string(currST->count++); // generate name of temporary variable
  while (currST->lookup(tmp_name, FIND) != NULL)
    tmp_name = "t" + to_string(currST->count++); // generate name of temporary variable
  Sym *s = new Sym(tmp_name);
  s->type = type;
  s->size = computeSize(type); // calculate the size of the current symbol
  s->init_val = init_val;
  currST->table[tmp_name] = *s; // push the newly created symbol in the Symbol table
  return &currST->table[tmp_name];
}

/*
 * backpatch:
 * A static method to backpatch a list of instructions
 * Gets list of instructions pointed by list1 and sets their result to the address addr
 */
void backpatch(list<int> list1, int addr) // backpatching
{
  string addr_str = to_string(addr); // get string form of the address
  list<int>::iterator it;
  it = list1.begin();

  while (it != list1.end())
  {
    QuadArray[*it].res = addr_str; // do the backpatching
    it++;
  }
}

/*
 * makelist:
 * A static method to create a new list with a single initial element l
 */
list<int> makelist(int l)
{
  list<int> newlist(1, l);
  return newlist;
}

/*
 * merge: merge 2 lists
 */
list<int> merge(list<int> &a, list<int> &b)
{
  a.merge(b); // merge two existing lists
  return a;   // return the merged list
}

/*
 * convert a boolean expression to integer expression
 */
Expression *convertBoolToInt(Expression *e) 
{
  if (e->isBoolean == true)
  {
    e->loc = gentemp(new SymType("int")); 
    backpatch(e->truelist, nextinstr());
    emit("=", e->loc->name, "true");
    int p = nextinstr() + 1;
    string str = to_string(p);
    emit("goto", str);
    backpatch(e->falselist, nextinstr());
    emit("=", e->loc->name, "false");
  }
  return e;
}

/*
 * convert an integer expression to boolean expression
*/
Expression *convertIntToBool(Expression *e) 
{
  if (e->isBoolean == false)
  {
    e->falselist = makelist(nextinstr()); 
    emit("==", "", e->loc->name, "0");    
    e->truelist = makelist(nextinstr());  
    emit("goto", "");
  }
  return e;
}

/*
 * Check if the symbol types are same or not
*/
bool typecheck(Sym *&s1, Sym *&s2) 
{
  SymType *type1 = s1->type; 
  SymType *type2 = s2->type; 
  if(type1 == NULL && type2 == NULL)
    return true;
  else if(type1 == NULL || type2 == NULL)
    return false;
  else
    return compareSymbolType(type1, type2); 
}

bool compareSymbolType(SymType *t1, SymType *t2) 
{
  int flag = 0;
  if (t1 == NULL && t2 == NULL)
    flag = 1; // if both symbol types are NULL
  else if (t1 == NULL || t2 == NULL || t1->type != t2->type)
    flag = 2; // if only one of them is NULL or if base type isn't same

  if (flag == 1)
    return true;
  else if (flag == 2)
    return false;
  else
    return compareSymbolType(t1->arrtype, t2->arrtype); 
}

int nextinstr()
{
  return QuadArray.size(); // next instruction will be 1+last index and lastindex=size-1. hence return size
}

int computeSize(SymType *t) // calculate size function
{
  if (t->type.compare("void") == 0)
    return 0;
  else if (t->type.compare("char") == 0)
    return size_of_char;
  else if (t->type.compare("int") == 0)
    return size_of_int;
  else if (t->type.compare("ptr") == 0)
    return size_of_pointer;
  else if (t->type.compare("func") == 0)
    return 0;
  else if (t->type.compare("arr") == 0)
    return t->width * computeSize(t->arrtype); // recursive for arrays (Multidimensional arrays)
  else
    return -1;
}

string printType(SymType *t) // Print type of variable(imp for multidimensional arrays)
{
  if (t == NULL)
    return "null";
  if (t->type.compare("void") == 0)
    return "void";
  else if (t->type.compare("char") == 0)
    return "char";
  else if (t->type.compare("int") == 0)
    return "int";
  else if (t->type.compare("ptr") == 0)
    return "ptr(" + printType(t->arrtype) + ")"; // recursive for ptr
  else if (t->type.compare("arr") == 0)
  {
    string str = to_string(t->width); // recursive for arrays
    return "arr(" + str + "," + printType(t->arrtype) + ")";
  }
  else if (t->type.compare("func") == 0)
    return "func";
  else if (t->type.compare("block") == 0)
    return "block";
  else
    return "NA";
}


/* 
 * generating the assembly code for the quad array
 */
int label_count = 0;
std::map<int, int> label_map;
// prepares the activation table for a given symtable 
void computeActivationRecord(SymTab* st) {
	int param = -24;
	int local = -20;

	// iterate over the symtable
	for (auto& it : st->table) {
		// if param
		if (it.second.category =="param") {
			param +=it.second.size;					// add the size of the entry	
			st->ar [it.second.name] = param;			// assign it to be param in activation record
		}
		else if (it.second.name=="retVal" || it.second.category=="func") continue;	
		else {
			local -=it.second.size;					// add the size of the entry
			st->ar [it.second.name] = local;			// assign it to be param in activation record
		}
	}
}

void gen_asm()
{
  // generate the assembly instructions
  for(auto& q : QuadArray){
    if(q.op == "goto" || q.op == "<=" || q.op == ">=" || q.op == "<" || q.op == ">" || q.op == "==" || q.op == "!="){
      if(q.res =="") continue;
      int instr_no = stoi(q.res);
      label_map[instr_no] = 1;
    }
  }
  for(auto& lb: label_map){
    lb.second = ++label_count;
  }

  vector<SymTab*> symtabs;
  for(auto& s : globalST->table){
    if(s.second.nested != NULL){
      symtabs.push_back(s.second.nested);
    }
  }
  for(auto& s : symtabs){
    computeActivationRecord(s);
  }

  // begin the .s file 
  map<string, bool> global_vars;
	for (auto& it : globalST->table) {
    Sym& entry = it.second;
		if (entry.category!="func") {
			// Global char
			if (entry.type->type=="char") { 
				if (entry.init_val!="") {
					std::cout << "\t.globl\t" << entry.name << "\n";
					std::cout << "\t.type\t" << entry.name << ", @object\n";
					std::cout << "\t.size\t" << entry.name << ", 1\n";
					std::cout << entry.name <<":\n";
					std::cout << "\t.byte\t" << stoi( entry.init_val) << "\n";
				}
				else {
					std::cout << "\t.comm\t" << entry.name << ",1,1\n";
				}
        global_vars[entry.name] = true;
			}
			// Global int
			if (entry.type->type=="int") { 
				if (entry.init_val!="") {
					std::cout << "\t.globl\t" << entry.name << "\n";
					std::cout << "\t.data\n";
					std::cout << "\t.align 4\n";
					std::cout << "\t.type\t" << entry.name << ", @object\n";
					std::cout << "\t.size\t" << entry.name << ", 4\n";
					std::cout << entry.name <<":\n";
					std::cout << "\t.long\t" << entry.init_val << "\n";
				}
				else {
					std::cout << "\t.comm\t" << entry.name << ",4,4\n";
				}
        global_vars[entry.name] = true;
			} 
      if(entry.type->type == "arr"){
        std::cout << "\t.comm\t" << entry.name << "," << entry.size << "," << 4 << "\n";
        global_vars[entry.name] = true;
      }
		}
	}
	// The strings from input (to be output in stdout)
	if ((int)allstrings.size()) {
		std::cout << "\t.section\t.rodata\n";
		for (vector<string>::iterator it = allstrings.begin(); it!=allstrings.end(); it++) {
			std::cout << ".LC" << it - allstrings.begin() << ":\n";
			std::cout << "\t.string\t" << *it << "\n";	
		}	
	}

	// begin the text segment
	std::cout << "\t.text	\n";

  vector<string> params;
  currST = globalST;
  bool make_quad = false;
	for (vector<Quad>::iterator it = QuadArray.begin(); it!=QuadArray.end(); it++) {
		if (label_map.count(it - QuadArray.begin())) {
			std::cout << ".L" << (2*label_count+label_map.at(it - QuadArray.begin()) + 2 )<< ": " << endl;
		}

		string op = it->op;
		string result = it->res; 
		string arg1 = it->arg1;
		string arg2 = it->arg2;
		string s=arg2;

    string result_ar;
    if(global_vars[result]) result_ar = result + "(%rip)";
    else result_ar = to_string(currST->ar[result]) + "(%rbp)";
    string arg1_ar;
    if(global_vars[arg1]) arg1_ar = arg1 + "(%rip)";
    else arg1_ar = to_string(currST->ar[arg1]) + "(%rbp)";
    string arg2_ar;
    if(global_vars[arg2]) arg2_ar = arg2 + "(%rip)";
    else arg2_ar = to_string(currST->ar[arg2]) + "(%rbp)";

		// if param -> add to the param list
		if(op=="param"){
			params.push_back(result);
		}
		else{
			std::cout << "\t";

			// Binary Operations
			// addition operation
			if (op=="+") {
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) {
					std::cout << "addl \t$" << stoi(arg2) << ", " << arg1_ar;
				}
				else {
					std::cout << "movl \t" << arg1_ar << ", " << "%eax" << endl;
					std::cout << "\tmovl \t" << arg2_ar<<", " << "%edx" << endl;
					std::cout << "\taddl \t%edx, %eax\n";
					std::cout << "\tmovl \t%eax, " << result_ar;
				}
			}
			// subtract operation
			else if (op=="-") {
				std::cout << "movl \t" << arg1_ar << ", " << "%eax" << endl;
				std::cout << "\tmovl \t" << arg2_ar << ", " << "%edx" << endl;
				std::cout << "\tsubl \t%edx, %eax\n";
				std::cout << "\tmovl \t%eax, " << result_ar ;
			}
			// multiplcation operator
			else if (op=="*") {
				std::cout << "movl \t" << arg1_ar << ", " << "%eax" << endl;
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) {
          std::cout<<"# "<<result<<" = " << arg1 << " * " << arg2 << endl;
          std::cout << "\timull \t$" << atoi(arg2.c_str()) << ", " << "%eax" << endl;
					SymTab* t = currST;
					string val;
					for (auto& it : t->table) {
						if(it.second.name==arg1) val=it.second.init_val; 
					}
				}
				else std::cout << "\timull \t" << arg2_ar << ", " << "%eax" << endl;
				std::cout << "\tmovl \t%eax, " << result_ar;			
			}
			// divide operation
			else if(op=="/") {
				std::cout << "movl \t" << arg1_ar << ", " << "%eax" << endl;
				std::cout << "\tcltd" << endl;
				std::cout << "\tidivl \t" << arg2_ar << endl;
				std::cout << "\tmovl \t%eax, " << result_ar;		
			}
      else if(op=="%") {
        std::cout << "movl \t" << arg1_ar << ", " << "%eax" << endl;
        std::cout << "\tcltd" << endl;
        std::cout << "\tidivl \t" << arg2_ar << endl;
        std::cout << "\tmovl \t%edx, " << result_ar;   
      }

			// copy
			else if (op=="=")	{
        if(make_quad == true){
          std::cout << "movq\t" << arg1_ar << ", " << "%rax" << endl;
          std::cout << "\tmovq \t%rax, " << result_ar;
          make_quad = false;
        } else {
          s=arg1;
          bool flag=true;
          if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
          else{
            char * p ;
            strtol(s.c_str(), &p, 10) ;
            if(*p == 0) flag=true ;
            else flag=false;
          }
          if (flag) 
            std::cout << "movl\t$" << stoi(arg1) << ", " << "%eax" << endl;
          else
            std::cout << "movl\t" << arg1_ar << ", " << "%eax" << endl;
          std::cout << "\tmovl \t%eax, " << result_ar;
        }
			}			
			else if (op=="=str")	{
				std::cout << "movq \t$.LC" << arg1 << ", " << result_ar;
			}
			// Relational Operations
			else if (op=="==") {
				std::cout << "movl\t" << arg1_ar << ", %eax\n";
				std::cout << "\tcmpl\t" << arg2_ar << ", %eax\n";
				std::cout << "\tje .L" << (2*label_count+label_map.at(stoi( result)) +2 );
			}
			else if (op=="!=") {
				cout << "movl\t" << arg1_ar << ", %eax\n";
				cout << "\tcmpl\t" << arg2_ar << ", %eax\n";
				cout << "\tjne .L" << (2*label_count+label_map.at(stoi( result)) +2 );
			}
			else if (op=="<") {
				cout << "movl\t" << arg1_ar << ", %eax\n";
				cout << "\tcmpl\t" << arg2_ar << ", %eax\n";
				cout << "\tjl .L" << (2*label_count+label_map.at(stoi( result )) +2 );
			}
			else if (op==">") {
				cout << "movl\t" << arg1_ar << ", %eax\n";
				cout << "\tcmpl\t" << arg2_ar << ", %eax\n";
				cout << "\tjg .L" << (2*label_count+label_map.at(stoi( result)) +2 );
			}
			else if (op==">=") {
				cout << "movl\t" << arg1_ar << ", %eax\n";
				cout << "\tcmpl\t" << arg2_ar << ", %eax\n";
				cout << "\tjge .L" << (2*label_count+label_map.at(stoi( result)) +2 );
			}
			else if (op=="<=") {
				cout << "movl\t" << arg1_ar << ", %eax\n";
				cout << "\tcmpl\t" << arg2_ar << ", %eax\n";
				cout << "\tjle .L" << (2*label_count+label_map.at(stoi( result)) +2 );
			}
			else if (op=="goto") {
				if(result!="") cout << "jmp .L" << (2*label_count+label_map.at(stoi( result)) +2 );
			}

			// Unary Operators
			else if (op=="=&") {
        cout << "# " << result << " = &" << arg1 << endl;
				cout << "leaq\t" << arg1_ar << ", %rax\n";
				cout << "\tmovq \t%rax, " <<  result_ar;
        make_quad = true;
			}
			else if (op=="=*") {
        cout << "# " << result << " = *" << arg1 << endl;
        cout << "movq\t" << arg1_ar << ", %rax\n";
        cout << "\tmovl\t(%rax), %eax\n";
        cout << "\tmovl \t%eax, " <<  result_ar;
			}
			else if (op=="*=") {
        cout << "# *" << result << " = " << arg1 << endl;
				cout << "movl\t" << result_ar << ", %eax\n";
				cout << "\tmovl\t" << arg1_ar << ", %edx\n";
				cout << "\tmovl\t%edx, (%eax)";
			} 			

			else if (op=="uminus") {
        cout << "movl\t" << arg1_ar << ", %eax\n";
        cout << "\tnegl\t%eax\n";
        cout << "\tmovl \t%eax, " <<  result_ar;
			}
			else if (op=="=[]") {
        cout<< "# =[] operation ; ";
        cout << result << " = " << arg1 << "[" << arg2 << "]"<<endl;

        if(global_vars[arg1]) {
          cout << "\tmovl\t" << arg2_ar << ", "<<"%eax" << endl;
          cout << "\tmovslq\t" << "%eax, "<<"%rdx" << endl;
          cout << "\tleaq\t" << "0(,%rdx,4), "<<"%rdx" << endl;
          cout << "\tleaq\t" << arg1_ar << ", "<<"%rax" << endl;
          cout << "\tmovl\t" << "(%rdx,%rax), "<<"%eax" << endl;
          cout << "\tmovl \t%eax, " <<  result_ar;

        } else {
          cout << "\tmovl\t" << arg2_ar << ", "<<"%ecx" << endl;
          cout << "\tmovl\t" << currST->ar[arg1]<< "(%rbp,%rcx,4), "<<"%eax" << endl;
          cout << "\tmovl \t%eax, " <<  result_ar;
        }
			}	 			
			else if (op=="[]=") {
        cout<< "# []= operation ; ";
        cout << result << "[" << arg1 << "]" << " = " << arg2<<endl;

        if(global_vars[result]) {
          cout << "\tmovl\t" << arg2_ar << ", "<<"%eax" << endl;
          cout << "\tmovl\t" << arg1_ar << ", "<<"%edx" << endl;
          cout << "\tmovslq\t" << "%edx, "<<"%rdx" << endl;
          cout << "\tleaq\t" << "0(,%rdx,4), "<<"%rcx" << endl;
          cout << "\tleaq\t" << result_ar << ", "<<"%rdx" << endl;
          cout << "\tmovl\t" << "%eax, "<<"(%rcx,%rdx)";
        } else{
          cout << "\tmovl\t" << arg1_ar << ", "<<"%eax" << endl;
          cout << "\tmovl\t" << arg2_ar << ", "<<"%edx" << endl;
          cout << "\tmovl\t" << "%edx, " << currST->ar[result]<< "(%rbp,%rax,4)";
        }
			}	 
			else if (op=="return") {
				if(result!="") cout << "movl\t" << result_ar << ", "<<"%eax\n";
        // jump to the function's epilogue
				cout << "jmp .LFE" << label_count;

			}
			else if (op=="param") {
				params.push_back(result);
			}

			// call a function
			else if (op=="call") {
				// Function Table
        for(int i=0; i<(int)params.size(); i++) {
          if(i==0) {
            // the first parameter to the function
            std::cout << "movl \t" << currST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
            std::cout << "\tmovq \t" << currST->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
          }
          else if(i==1) {
            // the second parameter to the function
            cout << "movl \t" << currST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
            cout << "\tmovq \t" << currST->ar[params[i]] << "(%rbp), " << "%rsi" << endl;
          }
          else if(i==2) {
            // the third parameter to the function
            cout << "movl \t" << currST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
            cout << "\tmovq \t" << currST->ar[params[i]] << "(%rbp), " << "%rdx" << endl;
          }
          else if(i==3) {
            // the fourth parameter to the function
            cout << "movl \t" << currST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
            cout << "\tmovq \t" << currST->ar[params[i]] << "(%rbp), " << "%rcx" << endl;
          }
          else {
            cout << "\tmovq \t" << currST->ar[params[i]] << "(%rbp), " << "%rdi" << endl;							
          }
				}
				params.clear();
				cout << "\tcall\t"<< arg1 << endl;
				cout << "\tmovl\t%eax, " << result_ar ;
			}

			else if (op=="Function") {
				// prologue of a function
				cout <<".globl\t" << result << "\n";
				cout << "\t.type\t"	<< result << ", @function\n";
				cout << result << ": \n";
				cout << ".LFB" << label_count <<":" << endl;
				cout << "\t.cfi_startproc" << endl;
				cout << "\tpushq \t%rbp" << endl;
				cout << "\t.cfi_def_cfa_offset 8" << endl;
				cout << "\t.cfi_offset 5, -8" << endl;
				cout << "\tmovq \t%rsp, %rbp" << endl;
				cout << "\t.cfi_def_cfa_register 5" << endl;
				currST = globalST->lookup(result)->nested;
				cout << "\tsubq\t$" << currST->table.rbegin()->second.offset+24 << ", %rsp"<<endl;
				
				// Function Table
				int i=0;
				for (auto it = currST->params.begin(); it!=currST->params.end(); it++) {
          if (i==0) {
            cout << "\tmovq\t%rdi, " << currST->ar[it->name] << "(%rbp)";
            i++;
          }
          else if(i==1) {
            cout << "\n\tmovq\t%rsi, " << currST->ar[it->name] << "(%rbp)";
            i++;
          }
          else if (i==2) {
            cout << "\n\tmovq\t%rdx, " << currST->ar[it->name] << "(%rbp)";
            i++;
          }
          else if(i==3) {
            cout << "\n\tmovq\t%rcx, " << currST->ar[it->name] << "(%rbp)";
            i++;
          }
				}
			}
				
			// epilogue of a function
			// function ends	
			else if (op=="FunctionEnd") {
				cout << ".LFE" << label_count++ <<":" << endl;
				cout << "leave\n";
				cout << "\t.cfi_restore 5\n";
				cout << "\t.cfi_def_cfa 4, 4\n";
				cout << "\tret\n";
				cout << "\t.cfi_endproc" << endl;
				cout << "\t.size\t"<< result << ", .-" << result;
			}
			else cout << "op";
			cout << endl;
		}
	}
	// footnote
	cout << 	"\t.ident\t	\"Compiled by 200101015\"\n";
	cout << 	"\t.section\t.note.GNU-stack,\"\",@progbits\n";

}



/*
 * MAIN FUNCTION
*/
int main(int argc, char **argv){
  globalST = new SymTab("Global");
  currST = globalST;

  // Parse the input file
  yyparse();

  // once parsing is completed, first update the global symbol table
  // with the required offset values
  globalST->update_offsets();

  std::cout << "\n";

  // Print the TAC and all the symbol tables
  if(argc > 1 && strcmp(argv[1], "-tac") == 0) {
    print_QuadArray();
    globalST->print();
  }
  if(argc > 1 && strcmp(argv[1], "-asm") == 0){
    gen_asm();
  }
};