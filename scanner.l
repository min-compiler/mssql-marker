%{
#include "parser.tab.h"
#include <ctype.h>
extern int zeile;
%}

LINE_COMMENT        [ ]*--.*
NEWLINE    			[\n]

LABEL               ([0-9a-zA-Z_]+):
CASE                (CASE|case)
WHEN                (WHEN|when)
THEN                (THEN|then)
ELSE                (ELSE|else)
END                 (END|end)
IF                  (IF|if)
BEGIN               (BEGIN|begin)
CATCH               (CATCH|catch)
WHILE               (WHILE|while)

BRACE_OPEN          [(]
BRACE_CLOSE         [)]

%x COMMENT 
%%

{LINE_COMMENT}      { /* skip */ }
"/*"                { BEGIN COMMENT; }
<COMMENT>(.)     { /* skip */ }
<COMMENT>(\n)        { zeile++; }
<COMMENT>"*/"       { BEGIN INITIAL; }

{NEWLINE}    		{ zeile++; }
{LABEL}             { return (OP_LABEL); }
{CASE}              { return (OP_CASE); }                
{WHEN}              { return (OP_WHEN); } 
{THEN}              { return (OP_THEN); } 
{ELSE}              { return (OP_ELSE); } 
{END}               { return (OP_END); } 
{IF}                { return (OP_IF); } 
{BEGIN}             { return (OP_BEGIN); } 
{CATCH}             { return (OP_CATCH); }
{WHILE}             { return (OP_WHILE); }
{BRACE_OPEN}        { return (BRACE_OPEN); } 
{BRACE_CLOSE}       { return (BRACE_CLOSE); } 

#[0-9a-zA-Z]+        { /*ignore*/ }
[^( |\n)]+           { return (CONTENT); }

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
