/*
calc.y:
Yacc Quelltext fuerer weiterten Taschenrechner
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

%token <dval> ZAHL
%token <ival> ID

%token KLAMMERAUF KLAMMERZU ASSIGNOP NL
%type <dval> zeile expr statm
%left ADD SUB
%left MUL DIV
%nonassoc UMINUS
%nonassoc ASSIGNOP
%%

zeile:      zeile NL            {printf("leereEingabe\n");}
            | zeile statm NL    {printf("Ergebnis:%f\n",$2);}
            | zeile error NL    {fprintf(stderr,"Fehler #1:'%s'\n", yytext); yyerrok;}
            | error NL          {fprintf(stderr,"Fehler #2:'%s'\n", yytext); yyerrok;}
            | statm NL          {printf("Ergebnis:%f\n",$1);}
            ;

statm:      expr                {$$=$1;}
            | ID ASSIGNOP expr  {$$=$3; symbole[$1]=$3;}
            ;

expr:       expr ADD expr       {$$ = $1 + $3;}
            | expr SUB expr     {$$ = $1 - $3;}
            | expr MUL expr     {$$ = $1 * $3;}
            | expr DIV expr     {$$ = $1 / $3;}
            | KLAMMERAUF expr KLAMMERZU {$$=$2;}
            | SUB expr %prec UMINUS {$$=$2;}
            | ZAHL              {$$=$1;}
            | ID                {$$=symbole[$1];}
            ;
%%
yyerror(){
    fprintf(stderr,"Syntaxfehler!\n");
}
main(){
    yyparse();
}
