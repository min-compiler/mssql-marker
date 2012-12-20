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
CATCH               {KEYWORD_START}(CATCH|catch){KEYWORD_END}
WHILE               {KEYWORD_START}(WHILE|while){KEYWORD_END}

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
{CATCH}             { return (OP_CATCH); }
{WHILE}             { return (OP_WHILE); }
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
