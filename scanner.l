LINE_COMMENT [ ]*--.*

GOTO GOTO[ ][^ ;]+
GOTO_LABEL [ ]*[^:\n]+:

%x COMMENT
%%

{GOTO}			{ printf("<GOTO> %s\n", yytext); }
{GOTO_LABEL}	{ printf("<GOTO LABEL> %s\n", yytext); }

{LINE_COMMENT} 	{ /* skip */ }
"/*" 			{ BEGIN COMMENT; }
<COMMENT>(.|\n) { /* skip */ }
<COMMENT>"*/" 	{ BEGIN INITIAL; }

.				{ /* skip */ }
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
