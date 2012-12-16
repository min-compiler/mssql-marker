flex: clean
	bison -d parser.y
	flex -o scanner.c scanner.l 

scanner: flex
	gcc -o parser parser.tab.c scanner.c

test-scanner: scanner
	./scanner scanner-test.txt

clean:
	rm -f scanner
	rm -f scanner.c
	rm -f parser-tab.c parser.tab.h parser

parser: scanner
	gcc -o parser parser.tab.c scanner.c
