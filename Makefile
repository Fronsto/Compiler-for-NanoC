CC = g++
NAME = A6_51
NC_DIR = TestInputNanoCPrograms
QUAD_DIR = GeneratedQuadFiles
ASM_DIR = GeneratedAssemblyCode
EXEC_DIR = GeneratedExecutables

all: a.out
	for number in 1 2 3 4 5 ; do \
		./a.out -tac < ${NC_DIR}/${NAME}_test$$number.nc > ${QUAD_DIR}/${NAME}_quads$$number.out ; \
		if [ $$? -eq 0 ] ; then \
			echo Test file $$number TAC generated ; \
		else \
			echo Test file $$number TAC generation failed ; \
		fi ; done
	for number in 1 2 3 4 5 ; do \
		./a.out -asm < ${NC_DIR}/${NAME}_test$$number.nc > ${ASM_DIR}/${NAME}_quads$$number.s ; \
		if [ $$? -eq 0 ] ; then \
			echo Test file $$number Assembly generated ; \
		else \
			echo Test file $$number Assembly generation failed ; \
		fi ; done 
	for number in 1 2 3 4 5 ; do \
		cd ${ASM_DIR} ; \
		gcc -c $(NAME)_quads$$number.s ; \
		cd .. ; \
		gcc ${ASM_DIR}/${NAME}_quads$$number.o -o ${EXEC_DIR}/test$$number -L. -lmyl -no-pie ; \
		if [ $$? -eq 0 ] ; then \
			echo Test file $$number Executable generated ; \
		else \
			echo Test file $$number Executable generation failed ; \
		fi ; done

libmyl.a:
	gcc -c iolib.c
	ar -rcs libmyl.a iolib.o

a.out: lex.yy.o y.tab.o ${NAME}_translator.o libmyl.a
	${CC} lex.yy.o y.tab.o ${NAME}_translator.o -lfl

${NAME}_translator.o: ${NAME}_translator.cpp ${NAME}_translator.h
	${CC} -c ${NAME}_translator.cpp

lex.yy.o: lex.yy.c
	${CC} -c lex.yy.c

y.tab.o: y.tab.c
	${CC} -c y.tab.c

lex.yy.c: $(NAME).l y.tab.h $(NAME)_translator.h
	flex $(NAME).l

y.tab.h y.tab.c: $(NAME).y 
	bison -dty $(NAME).y 

clean:
	rm a.out lex.yy.* $(NAME)_translator.o *.tab.* **/${NAME}_quads*.o **/test* iolib.o libmyl.a
