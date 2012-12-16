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


%token OP_CASE
%token OP_WHEN
%token OP_THEN
%token OP_ELSE
%token OP_END
%token OP_IF
%token OP_BEGIN
%token OP_TRY
%token OP_CATCH
%token OP_GOTO
%token OP_RETURN
%token OP_WHILE

%token OP_DELAY
%token OP_TIME
%token OP_WAITFOR

%token OP_BREAK
%token OP_CONTINUE
%token OP_THROW
%token OP_DECLARE
%token OP_EXECUTE
%token OP_PRINT
%token OP_RAISEERROR

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
