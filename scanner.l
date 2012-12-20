%{
#include "parser.tab.h"
#include <ctype.h>
%}

LINE_COMMENT        [ ]*--.*

KEYWORD_START       ([ ]*)|^
KEYWORD_END         [ \n]+
LABEL               {KEYWORD_START}([0-9a-zA-Z_]+):{KEYWORD_END}
CASE                {KEYWORD_START}(CASE|case){KEYWORD_END}
WHEN                {KEYWORD_START}(WHEN|when){KEYWORD_END}
THEN                {KEYWORD_START}(THEN|then){KEYWORD_END}
ELSE                {KEYWORD_START}(ELSE|else){KEYWORD_END}
END                 {KEYWORD_START}(END|end){KEYWORD_END}
IF                  {KEYWORD_START}(IF|if){KEYWORD_END}
BEGIN               {KEYWORD_START}(BEGIN|begin){KEYWORD_END}
TRY                 {KEYWORD_START}(TRY|try){KEYWORD_END}
CATCH               {KEYWORD_START}(CATCH|catch){KEYWORD_END}
GOTO                {KEYWORD_START}(GOTO|goto){KEYWORD_END}
RETURN              {KEYWORD_START}(RETURN|return){KEYWORD_END}
WHILE               {KEYWORD_START}(WHILE|while){KEYWORD_END}

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

{LABEL}             { return (OP_LABEL); }
{CASE}              { return (OP_CASE); }                
{WHEN}              { return (OP_WHEN); } 
{THEN}              { return (OP_THEN); } 
{ELSE}              { return (OP_ELSE); } 
{END}               { return (OP_END); } 
{IF}                { return (OP_IF); } 
{BEGIN}             { return (OP_BEGIN); } 
{TRY}               { return (OP_TRY); } 
{CATCH}             { return (OP_CATCH); } 
{GOTO}              { return (OP_GOTO); } 
{RETURN}            { return (OP_RETURN); } 
{WHILE}             { return (OP_WHILE); } 
{DELAY}             { return (OP_DELAY); } 
{TIME}              { return (OP_TIME); } 
{WAITFOR}           { return (OP_WAITFOR); } 
{BREAK}             { return (OP_BREAK); } 
{CONTINUE}          { return (OP_CONTINUE); } 
{THROW}             { return (OP_THROW); } 
{DECLARE}           { return (OP_DECLARE); } 
{EXECUTE}           { return (OP_EXECUTE); } 
{PRINT}             { return (OP_PRINT); } 
{RAISEERROR}        { return (OP_RAISEERROR); } 
{BRACE_OPEN}        { return (BRACE_OPEN); } 
{BRACE_CLOSE}       { return (BRACE_CLOSE); } 

#[0-9a-zA-Z]+        { /*ignore*/ }
.                   { return (CONTENT); }

%%
yywrap(){}

/*
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
*/
