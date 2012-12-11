build: clean
	bison -d calc.y
	flex calc.l
	gcc -o calc calc.tab.c lex.yy.c

clean:
	rm -f calc.tab.c calc.tab.h lex.yy.c   
  

