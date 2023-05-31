# Compiler for NanoC
This is a part of a course assignment I did in my sixth semester at IIT Guwahati in the course Implementation of Programming Languages Lab. 
It uses **Flex** for lexical analysis, **Bison** for syntax and semantic analysis, and finally the generated quad array (three address code) is converted to the target x86-64 assembly by the C++ program. 

## What the heck is NanoC, I hear you ask
NanoC is a subset of C with most of its core features, designed to ease up the assignment (making a compiler for C with all its details and intricacies would be too much and would take a lot more time than half a semester). It includes, among other things, support for 
- pointers, 
- 1D arrays, 
- boolean expressions, 
- functions (with support for recursive calls), 
- iterative statements (for loop), 
- conditional statements (if-else) and 
- separate function scopes. 

[Assignment3](/Assignment\ 3) contains the entire description of NanoC (with its Lexical Grammar and Phase Structure Grammar).

## Working of the Compiler
// ... to complete

## Build and Run
Just run 
```
$ make
```
 It will create the executable for the compiler and it will start compiling the sample nanoC programs in the `TestInputNanoCPrograms` directory. Executables by the name `test{i}` (i varing from 1 to 5) are created in the `GeneratedExecutables` directory.

## Resources
Some resources that helped me in building this-
- [Bison's Manual](https://www.gnu.org/software/bison/manual/)
- [NASM tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
- [Stack Frame Layout by Eli Bendersky](https://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64/)
- GCC compiler (I ran gcc -S on simple C programs to see how it generated the assembly)

## Unresolved issues
1. functions must end with a return statement. The last statement should be a return statement.
2. At max 3 params can be passed to the functions.
3. Pointers may give unexpected results. 
