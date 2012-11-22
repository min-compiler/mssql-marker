LINE_COMMENT        [ ]*--.*

KEYWORD_START       ([ ]*)|^
KEYWORD_END         [ \n]+
CASE	            {KEYWORD_START}(CASE|case){KEYWORD_END}
WHEN	            {KEYWORD_START}(WHEN|when){KEYWORD_END}
THEN	            {KEYWORD_START}(THEN|then){KEYWORD_END}
ELSE	            {KEYWORD_START}(ELSE|else){KEYWORD_END}
END	                {KEYWORD_START}(END|end){KEYWORD_END}
IF	                {KEYWORD_START}(IF|if){KEYWORD_END}
BEGIN   	        {KEYWORD_START}(BEGIN|begin){KEYWORD_END}
TRY	                {KEYWORD_START}(TRY|try){KEYWORD_END}
CATCH	            {KEYWORD_START}(CATCH|catch){KEYWORD_END}
GOTO    	        {KEYWORD_START}(GOTO|goto){KEYWORD_END}
RETURN    	        {KEYWORD_START}(RETURN|return){KEYWORD_END}
WHILE    	        {KEYWORD_START}(WHILE|while){KEYWORD_END}

DELAY               {KEYWORD_START}(DELAY|delay){KEYWORD_END}
TIME                {KEYWORD_START}(TIME|time){KEYWORD_END}
WAITFOR             {KEYWORD_START}(WAITFOR|waitfor){KEYWORD_END}

BREAK               {KEYWORD_START}(BREAK|break){KEYWORD_END}
CONTINUE            {KEYWORD_START}(CONTINUE|continue){KEYWORD_END}
THROW               {KEYWORD_START}(THROW|throw){KEYWORD_END}
DECLARE             {KEYWORD_START}(DECLARE|declare){KEYWORD_END}
EXECUTE             {KEYWORD_START}(EXECUTE|execute){KEYWORD_END}
PRINT               {KEYWORD_START}(PRINT|print){KEYWORD_END}
RAISEERROR          {KEYWORD_START}(RAISEERROR|raiseerror){KEYWORD_END}

BRACE_OPEN          [(]
BRACE_CLOSE         [)]


%x COMMENT
%%

{LINE_COMMENT}      { /* skip */ }
"/*"                { BEGIN COMMENT; }
<COMMENT>(.|\n)     { /* skip */ }
<COMMENT>"*/"       { BEGIN INITIAL; }

{CASE}              { printf("CASE "); }  	            
{WHEN}	            { printf("WHEN "); } 
{THEN}	            { printf("THEN "); } 
{ELSE}	            { printf("ELSE "); } 
{END}	            { printf("END "); } 
{IF}	            { printf("IF "); } 
{BEGIN}   	        { printf("BEGIN "); } 
{TRY}	            { printf("TRY "); } 
{CATCH}	            { printf("CATCH "); } 
{GOTO}    	        { printf("GOTO "); } 
{RETURN}    	    { printf("RETURN "); } 
{WHILE}    	        { printf("WHILE "); } 
{DELAY}             { printf("DELAY "); } 
{TIME}              { printf("TIME "); } 
{WAITFOR}           { printf("WAITFOR "); } 
{BREAK}             { printf("BREAK "); } 
{CONTINUE}          { printf("CONTINUE "); } 
{THROW}             { printf("THROW "); } 
{DECLARE}           { printf("DECLARE "); } 
{EXECUTE}           { printf("EXECUTE "); } 
{PRINT}             { printf("PRINT "); } 
{RAISEERROR}        { printf("RAISEERROR "); } 
{BRACE_OPEN}        { printf("BRACE_OPEN "); } 
{BRACE_CLOSE}       { printf("BRACE_CLOSE "); } 

[0-9a-zA-Z]+        { /* skip */ }
.                   { /* skip */ }

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
