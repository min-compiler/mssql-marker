LINE_COMMENT    [ ]*--.*

GOTO            (GOTO|goto)[ ][^ ;]+
GOTO_LABEL      ^[ ]*[^:\n ]+:

TIME_LITERAL    '[0-9]{1,2}:[0-9]{1,2}'
WAIT_FOR        ^[ ]*(WAITFOR|waitfor)[ ]({WAIT_FOR_DELAY}|{WAIT_FOR_TIME})
WAIT_FOR_DELAY  (DELAY|delay)[ ](@[^ \n;]+|{TIME_LITERAL})
WAIT_FOR_TIME   (TIME|time)[ ]{TIME_LITERAL}

BEGIN           (begin|BEGIN)[ \n]+
END             (end|END)[;\n]+

ALPHA		[a-zA-Z]
NUM		[0-9]
EXPRESSION	@{ALPHA}({ALPHA}|{NUM})*
INTEGER         {NUM}+
RETURN_REGEX    (RETURN|return)[ ]?
RETURN_EXP      {RETURN_REGEX}({INTEGER}|{EXPRESSION})

WHILE           (while|WHILE)[ ]
WHILE_EXP       {WHILE}{EXPRESSION}

%x COMMENT
%%

{WHILE_EXP}     { printf("<WHILE> '%s'", yytext); }

{RETURN_EXP}    { printf("<RETURN> '%s'", yytext); }

{GOTO}          { printf("<GOTO> %s\n", yytext); }
{GOTO_LABEL}    { printf("<GOTO LABEL> %s\n", yytext); }

{WAIT_FOR}      { printf("<WAITFOR> %s\n", yytext); }

{BEGIN}         { printf("<BEGIN> %s\n", yytext); }
{END}           { printf("<END> %s\n", yytext); }

{LINE_COMMENT}  { /* skip */ }
"/*"            { BEGIN COMMENT; }
<COMMENT>(.|\n) { /* skip */ }
<COMMENT>"*/"   { BEGIN INITIAL; }

.               { /* skip */ }
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
