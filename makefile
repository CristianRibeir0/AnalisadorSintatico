all:
	clear
	lex lexico.l
	yacc -d parser.y
	g++ -o analizador y.tab.c -ll

	./analizador < codigo01.txt