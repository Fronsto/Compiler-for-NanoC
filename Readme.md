# Compiler for NanoC
This is a part of a course assignment I did in my sixth semester at IIT Guwahati in the course Implementation of Programming Languages Lab. 
It uses **Flex** for lexical analysis, **Bison** for syntax and semantic analysis, and finally the generated quad array (three address code) is converted to the target x86-64 assembly by the C++ program. 

# What the heck is NanoC, I hear you ask
NanoC is a subset of C with most of its core features, designed to ease up the assignment (making a compiler for C with all its details and intricacies would be too much and would take a lot more time than half a semester). It includes, among other things, support for 
- pointers, 
- 1D arrays, 
- boolean expressions, 
- functions (with support for recursive calls), 
- iterative statements (for loop), 
- conditional statements (if-else) and 
- separate function scopes. 

[Assignment3](/Assignment%203.pdf) contains the entire description of NanoC (with its Lexical Grammar and Phase Structure Grammar).

# Working of the Compiler
Before we begin lets take a note of the parts this compiler is made up of: first we have the Lexer, then the Parser, and finally the C++ Program containing auxiliary data structures including the Symbol Table and the Quad Array. Now lets talk about the process of compilation.

## The Lexer
The first step in the compilation process is generation of “tokens” from the source code by the lexer, which are then fed into the parser. 

### What it does and why
The lexer reads the source code character by character. Many characters hold special significance in the language's lexical specification, such as semicolons, braces, or keywords. Additionally, there are user-defined elements like identifiers, which include variable names and function names. However, the compiler's main concern is generating the assembly code, not the exact names of these elements. 

To simplify the representation of these elements, the lexer combines them into single entities known as "tokens." Tokens consist of three main components: a name, a value, and an ID. The name provides a human-readable description of the token, while the value represents the specific sequence of characters it represents. Meanwhile, the ID is an integer assigned to the token by the compiler. By reducing these language elements to tokens, the compiler can treat them uniformly. As long as tokens for different keywords like "if" and "while" are assigned distinct IDs, the compiler can effectively carry out its tasks.

### How is it implemented
Lexers are [DFAs](https://www.cs.rochester.edu/u/nelson/courses/csc_173/fa/fa.html). Flex generates the code for us, we just have to provide it with the lexical structure of the language.

The lexical structure is provided in the `.l` file as a bunch of regex. Whenever certains patterns are met, the lexer generates a token for the same. This can be done either in a single run where the lexer goes through the entire file and generates all the tokens, or it can be done interactively (which is what's done in this implementation) where the parser calls the lexer repeatedly to provide it with a single token that the parse then processes.

## The Parser
### What is does and why
Paarser takes up those tokens and translates them to un-optimized instructions, stored in a data structure called the "quad array". There's also a symbol table that keeps track of all the indentifiers (variable and funcitons names, and various temporary variables created by the parser). The C++ Program provides with methods to do operations over these data structures, and the parser, as it sees a specific sequence of such tokens, executes certain actions that in the end fills up the quad array and the symbol table. From there, the C++ Program picks over and use it to generate teh assembly code.

### How is it implemented
Parsers are [PDAs](https://courses.cs.washington.edu/courses/cse431/19au/Parsing.pdf). Bison generates the code for us, we just have to provide it with the phase structure grammar of our language - and the associated actions - in the `.y` file.

The parser bison generates works by applying shift-reduce operations. When it recieves a token, it shifts it onto the stack. But if the parser sees the list of tokens on top of the stack can be reduced to a single one, it reduces them (its a bottom-up parser). There's also a look-ahead token (it parses LALR(1) grammar) - it waits for the next token before applying a reduce operation. All this is gonna be important to prevent conflicts in the parsing process. Even if there are conflicts, bison can parse the grammar perfectly - it just won't be as efficient, since bison is optimized to parse LALR(1) grammars.

## The C++ Program - from the quad array to the assembly code
The final stage is the generation of the assembly code. Actually there's an optimization phase also - where we reduce the number of instructions generated from the previous phase - but in this implemenation we skipped that. 

### Before we go on to assembly code generation
First lets talk about the 2 data structures used - quad array and symbol table. In general, the intermediate code generated can be stored in various formats. The one used here is QuadArray - a 4-tuple (operation, arg1, arg2, result). Purpose of the symbol table it know during the compilation which all symbols have been spotted, and for the final code generation to know how much space is needed.
Additionally, take a note of these 2 things -
- **Scopes**. Actions are executed - like changing the symbol table. When compiler reads a function definition, it creates a new symbol table, switches to it, so now all symbols spotted are stored in this symbol table. This way, scopes are defined.
- **Branch statements**. Like if, or for loop. When reducing those, the grammar is augmented with markers for gotos. Where to go to? thats left hinged, stored and knitted together when these branch statements are reduced. Doing this is called “backpatching”.

### Now, about generation of assembly code
In this implementation, optimization of the intermediate code was not included. As a result, the focus was primarily on generating the corresponding assembly instructions from the quad array. However, one crucial aspect that required attention was the implementation of functions, ensuring proper stack management and handling.

The symbol table plays a crucial role in allocating the necessary space for each function within the compiler. When a function invocation is detected, the compiler utilizes the symbol table to determine the required space for the function. This space includes storage for variables, parameters, return values, and other relevant information.

During the function's execution, the compiler sets the rbp (base pointer) to the current value of rsp (stack pointer). This establishes a reference point for accessing the function's local variables and parameters relative to the stack frame. The compiler then decrements the rsp to reserve space on the stack for all the variables that will be utilized within the function. By effectively managing the stack through the use of rbp and rsp, the compiler ensures that each function operates within its allocated memory space and respects the desired scoping rules.

# Build and Run
Just run 
```
$ make
```
 It will create the executable for the compiler and it will start compiling the sample nanoC programs in the `TestInputNanoCPrograms` directory. Executables by the name `test{i}` (i varing from 1 to 5) are created in the `GeneratedExecutables` directory.

# Resources
Some resources that helped me in building this-
- [Bison's Manual](https://www.gnu.org/software/bison/manual/)
- [NASM tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
- [Stack Frame Layout by Eli Bendersky](https://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64/)
- The GCC compiler (The way I took its help was via running gcc -S on simple C programs to see how it generated the assembly)

# Unresolved issues
1. functions must end with a return statement. The last statement should be a return statement.
2. At max 3 params can be passed to the functions.
3. Pointers may give unexpected results. 
