flex: clean
	flex -o scanner.c scanner.l 

scanner: flex
	gcc scanner.c -lfl -o scanner

test-scanner: scanner
	./scanner scanner-test.txt > scanner_result.txt

clean:
	rm -f scanner
	rm -f scanner.c
