/*
parser.y:
*/

%{

#include<stdio.h>
#include<math.h>

extern char *yytext;
double symbole[26];

%}
%union {
    double dval;
    int ival;
}


%token CASE
%token WHEN
%token THEN
%token ELSE
%token END
%token IF
%token BEGIN
%token TRY
%token CATCH
%token GOTO
%token RETURN
%token WHILE

%token DELAY
%token TIME
%token WAITFOR

%token BREAK
%token CONTINUE
%token THROW
%token DECLARE
%token EXECUTE
%token PRINT
%token RAISEERROR

%token BRACE_OPEN
%token BRACE_CLOSE

%token CONTENT

%%

statement:      statement CONTENT   {}
                | CONTENT           {}
                ;
%%

yyerror(){
    fprintf(stderr,"Syntaxfehler!\n");
}
main(){
    yyparse();
}
