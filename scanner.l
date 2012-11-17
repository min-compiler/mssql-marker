LINE_COMMENT [ ]*--.*

%x COMMENT
%%
{LINE_COMMENT} { 
	/* skip */
	}
	
"/*" { BEGIN COMMENT; }

<COMMENT>(.|\n) { /* skip */ }

<COMMENT>"*/" { BEGIN INITIAL; }
%%

int main(int argc, char* argv[]) {
	if (argc > 1) {
		char* filename = argv[1];
		printf("opening %s as test data ...\n", filename);
		yyin = fopen(filename, "r");
	} else {
		yyin = stdin;
	}

	yylex();
}
