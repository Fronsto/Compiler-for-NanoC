%{
	#include <stdio.h>
	#include <string.h>
	#include "A6_51_translator.h"
  #include "y.tab.h" // created by bison that stores the macros for the tokens

  extern YYSTYPE yylval;
%}

%option noyywrap

KEYWORD_CHAR "char"
KEYWORD_ELSE "else"
KEYWORD_FOR "for"
KEYWORD_IF "if"
KEYWORD_INT "int"
KEYWORD_RETURN "return"
KEYWORD_VOID "void"

IDENTIFIER [a-zA-Z_][a-zA-Z_0-9]*


BRK_SQ_OPEN "["
BRK_SQ_CLOSE "]"
BRK_ROUND_OPEN "("
BRK_ROUND_CLOSE ")"
BRK_CURLY_OPEN "{"
BRK_CURLY_CLOSE "}"
ARROW "->"
AMPERSAND "&"
ASTERISK "*"
PLUS "+"
MINUS "-"
DIVISION "/"
MODULO "%"
EXCLAMATION "!"
QUESTION "?"
LESS_THAN "<"
GREATER_THAN ">"
LESS_THAN_EQUAL "<="
GREATER_THAN_EQUAL ">="
EQUAL "=="
NOT_EQUAL "!="
AND "&&"
OR "||"
ASSIGN "="
COLON ":"
SEMICOLON ";"
COMMA "," 

INT_CONSTANT 0|([1-9][0-9]*)

ESCAPE_SEQUENCE             "\\\'"|"\\\""|"\\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"

C_CHAR                      [^\'\n\\]|{ESCAPE_SEQUENCE}
CHAR_CONSTANT               \'({C_CHAR}+)\'  

CONSTANT {INT_CONSTANT}|{CHAR_CONSTANT}

S_CHAR                      [^\"\n\\]|{ESCAPE_SEQUENCE}
STRING_LITERAL              \"({S_CHAR}*)\"

WS [ \t\n]+

%x  MULTI_LINE_COMMENT
%x  SINGLE_LINE_COMMENT

%%
  /* rules section */

"//" {
  BEGIN(SINGLE_LINE_COMMENT);
}
<SINGLE_LINE_COMMENT>.    {  }
<SINGLE_LINE_COMMENT>\n   { BEGIN(INITIAL);  }

"/*" {  
  BEGIN(MULTI_LINE_COMMENT); 
}
<MULTI_LINE_COMMENT>"*/" { BEGIN(INITIAL); }
<MULTI_LINE_COMMENT>.    {  }
<MULTI_LINE_COMMENT>\n   {  }

{KEYWORD_CHAR} { return CHAR; }
{KEYWORD_ELSE} { return ELSE; }
{KEYWORD_FOR} { return FOR; }
{KEYWORD_IF} { return IF; }
{KEYWORD_INT} { return INT; }
{KEYWORD_RETURN} { return RETURN; }
{KEYWORD_VOID} { return VOID; }

  /* separate return statement for each punctuator */
{BRK_SQ_OPEN} { return '['; }
{BRK_SQ_CLOSE} { return ']'; }
{BRK_ROUND_OPEN} { return '('; }
{BRK_ROUND_CLOSE} { return ')'; }
{BRK_CURLY_OPEN} { return '{'; }
{BRK_CURLY_CLOSE} { return '}'; }
{ARROW} { return ARROW; }
{AMPERSAND} { return AMPERSAND; }
{ASTERISK} { return ASTERISK; }
{PLUS} { return PLUS; }
{MINUS} { return MINUS; }
{DIVISION} { return DIVISION; }
{MODULO} { return MODULO; }
{EXCLAMATION} { return EXCLAMATION; }
{QUESTION} { return '?'; }
{LESS_THAN} { return LESS_THAN; }
{GREATER_THAN} { return GREATER_THAN; }
{LESS_THAN_EQUAL} { return LESS_THAN_EQUAL; }
{GREATER_THAN_EQUAL} { return GREATER_THAN_EQUAL; }
{EQUAL} { return EQUAL; }
{NOT_EQUAL} { return NOT_EQUAL; }
{AND} { return AND; }
{OR} { return OR; }
{ASSIGN} { return '='; }
{COLON} { return ':'; }
{SEMICOLON} { return ';'; }
{COMMA} { return ','; }


{IDENTIFIER} { 
  yylval.sym_ptr = currST->lookup(yytext);
  return IDENTIFIER; 
}

{INT_CONSTANT} { 
  yylval.int_val = atoi(yytext);
  return INT_CONSTANT; 
}
{CHAR_CONSTANT} { 
  yylval.char_val = yytext;
  return CHAR_CONSTANT; 
}
{STRING_LITERAL} { 
  yylval.char_val = yytext;
  return STRING_LITERAL; 
}

{WS} { /* skip white space */ }

. { return INVALID_TOKEN; }

%%
/* main in another file */