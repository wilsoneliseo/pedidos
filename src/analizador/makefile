all: salidas

salidas: lexico.h lexico.c sintactico.h sintactico.c

lexico.h lexico.c: scanner.l
	flex $<

sintactico.h sintactico.c: parser.y
	bison -v -l $<
