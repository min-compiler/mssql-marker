WHITESPACE	[ ]
CASE_REGEX	(CASE|case)
WHEN_REGEX	(WHEN|when)
THEN_REGEX	(THEN|then)
ELSE_REGEX	(ELSE|else)
END_REGEX	(END|end)
ALPHA		[a-zA-Z]
NUM			[0-9]
EXPRESSION	{ALPHA}({ALPHA}|{NUM})*

%x CASE WHEN_INIT WHEN THEN_INIT THEN ELSE_INIT ELSE END 
%%

<INITIAL>{
	{CASE_REGEX}	printf("c:'%s'", yytext);BEGIN(CASE);
	{EXPRESSION}	BEGIN(INITIAL);
	.				// filter useless stuff
}

<CASE>{
	{CASE_REGEX}	BEGIN(INITIAL);
	{WHEN_REGEX}	printf("w:'%s'", yytext);BEGIN(WHEN_INIT);
	{EXPRESSION}	printf("ex:'%s'", yytext);
}

<WHEN_INIT>{
	{WHEN_REGEX}	BEGIN(INITIAL);
	{EXPRESSION}	printf("ex:'%s'", yytext);BEGIN(WHEN);
}

<WHEN>{
	{WHEN_REGEX}	BEGIN(INITIAL);
	{THEN_REGEX}	printf("t:'%s'", yytext);BEGIN(THEN_INIT);
	{EXPRESSION}	printf("ex:'%s'", yytext);
}

<THEN_INIT>{
	{THEN_REGEX}	BEGIN(INITIAL);
	{EXPRESSION}	printf("ex:'%s'", yytext);BEGIN(THEN);
}

<THEN>{
	{THEN_REGEX}	BEGIN(INITIAL);
	{WHEN_REGEX}	printf("w:'%s'", yytext);BEGIN(WHEN_INIT);
	{ELSE_REGEX}	printf("el:'%s'", yytext);BEGIN(ELSE_INIT);
	{END_REGEX}		printf("e:'%s'", yytext);BEGIN(END);
}

<ELSE_INIT>{
	{ELSE_REGEX}	BEGIN(ELSE);
	{EXPRESSION} 	printf("ex:'%s'", yytext);BEGIN(ELSE);
}

<ELSE>{
	{ELSE_REGEX}	BEGIN(INITIAL);
	{END_REGEX}		printf("e:'%s'", yytext);BEGIN(END);
	{EXPRESSION}	printf("ex:'%s'", yytext);	
}

<END>{
	.				BEGIN(INITIAL);
}

%%

int main(int argc, char* argv[])
{
	if (argc > 1)
	{
		char* filename = argv[1];
		printf("opening %s as test data ...\n", filename);
		yyin = fopen(filename, "r");
	}
	else
	{
		yyin = stdin;
	}

	yylex();
}
