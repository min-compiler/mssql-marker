flex: clean
	flex -o scanner.c scanner.l 
	flex -o case_scanner.c case_scanner.lex

scanner: flex
	gcc scanner.c -lfl -o scanner
	gcc case_scanner.c -lfl -o case_scanner

test-scanner: scanner
	./scanner scanner-test.txt
	./case_scanner example.txt > result.txt

clean:
	rm -f scanner
	rm -f scanner.c
	rm -f case_scanner
	rm -f case_scanner.c
