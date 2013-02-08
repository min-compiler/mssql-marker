/*
parser.y:
*/

%{

#include<stdio.h>
#include<math.h>
#include<string.h>

int zeile=1;

extern char *yytext;
double symbole[26];

%}

%union {
    double dval;
    int ival;
    char cval;
    char *strval;
}

%type <strval> OP_LABEL OP_CASE OP_WHEN OP_THEN OP_END OP_IF OP_BEGIN OP_CATCH OP_WHILE BRACE_OPEN BRACE_CLOSE CONTENT PSEUDO_THEN OP_ELSE
%type <strval> _statement_list _case _operation _while _label _condition_else _catch _if _if_then _stmt_block _condition_list _condition _statement _content_word _braces

%left OP_LABEL OP_CASE OP_WHEN OP_THEN OP_END OP_IF OP_BEGIN OP_CATCH OP_WHILE BRACE_OPEN BRACE_CLOSE 
%right CONTENT
%nonassoc PSEUDO_THEN
%nonassoc OP_ELSE
%%
_statement_list: _statement_list _statement
                | _statement
                ;
                
_statement:     _content_word                   { char* s=malloc(sizeof(char)*(strlen($1))); strcpy(s, $1); $$ = s; }          
                | _operation                    { char* s=malloc(sizeof(char)*(strlen($1)));  strcpy(s, $1); $$ = s; }
                ;
                
_content_word:  CONTENT _content_word           { char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));  strcpy(s, $1); strcat(s," "); strcat(s, $2); $$ = s; }
                | CONTENT                       { char* s=malloc(sizeof(char)*(strlen($1)));  strcpy(s, $1); $$ = s; }                                    
                | CONTENT BRACE_OPEN BRACE_CLOSE _content_word { char* s=malloc(sizeof(char)*(strlen($1)+strlen($4)+3)); strcpy(s,$1); strcat(s,"("); strcat(s,") "); strcat(s,$4); $$=s; }
                | CONTENT BRACE_OPEN _content_word BRACE_CLOSE _content_word { char* s=malloc(sizeof(char)*(strlen($1)+strlen($3)+strlen($5)+3)); strcpy(s,$1); strcat(s,"("); strcat(s, $3); strcat(s,") "); strcat(s,$5); $$=s; }
                | CONTENT BRACE_OPEN BRACE_CLOSE  { char* s=malloc(sizeof(char)*(strlen($1)+2)); strcpy(s, $1); strcat(s,"()"); $$ = s; } 
                | CONTENT BRACE_OPEN _content_word BRACE_CLOSE  { char* s=malloc(sizeof(char)*(strlen($1)+strlen($3)+2));  strcpy(s, $1); strcat(s,"("); strcat(s,$3); strcat(s, ")"); $$ = s; } 
                ;
                
_operation:     _while _statement {printf("%s%s\n", $1, $2);}
                | _case {printf("%s", $1);}
                | _label _statement {printf("%s%s\n", $1, $2);}
                | _catch {printf("%s", $1);}
                | _if {printf("%s", $1);}
                ;
                
_while:         OP_WHILE                { char* s=malloc(sizeof(char)*7); strcpy(s, "WHILE "); $$ = s; } 
                ;
                
_label:         OP_LABEL    { char* s=malloc(sizeof(char)*(strlen(yytext)+1)); strcpy(s, yytext); strcat(s,"\n"); $$ = s; }
                ;

_case:          OP_CASE _condition_list OP_END                                  {char* s=malloc(sizeof(char)*(strlen($2)+12)); strcpy(s,"CASE\n"); strcat(s,$2); strcat(s, "\n"); strcat(s,"\n END\n"); $$ = s;}
                | OP_CASE _condition_list _condition_else OP_END                {char* s=malloc(sizeof(char)*(strlen($2)+strlen($3)+12)); strcpy(s,"CASE\n"); strcat(s, $2); strcat(s, "\n"); strcat(s, $3);strcat(s,"\nEND\n"); $$ = s; }
                | OP_CASE _statement _condition_list OP_END                     { char* s=malloc(sizeof(char)*(strlen($2)+strlen($3)+12)); strcpy(s,"CASE "); strcat(s, $2); strcat(s, "\n"); strcat(s, $3);strcat(s,"\nEND\n"); $$ = s; }
                | OP_CASE _statement _condition_list _condition_else OP_END     { char* s=malloc(sizeof(char)*(strlen($2)+strlen($3)+strlen($4)+12)); strcpy(s,"CASE "); strcat(s, $2); strcat(s, "\n"); strcat(s, $3); strcat(s, "\n"); strcat(s, $4); strcat(s,"\nEND\n"); $$ = s; }
                ;          

_condition_else:     OP_ELSE _statement_list { char* s=malloc(sizeof(char)*(strlen($2)+7)); strcpy(s, "ELSE "); strcat(s, $2); $$ = s; }
                ;  

_catch:         OP_CATCH _statement OP_END OP_CATCH     {  char* s=malloc(sizeof(char)*(strlen($2)+18)); strcpy(s, "CATCH\n"); strcat(s, $2); strcat(s,"\nEND CATCH\n"); $$ = s; }
                ;


_if:    _if_then %prec PSEUDO_THEN             { char* s=malloc(sizeof(char)*(strlen($1))); strcpy(s, $1); $$ = s;}
        | _if_then OP_ELSE _stmt_block         { char* s=malloc(sizeof(char)*(strlen($1)+strlen($3)+6)); strcpy(s, $1); strcat(s," ELSE\n"); strcat(s,$3); strcat(s, "\n");$$ = s; }
        ;

_if_then:       OP_IF _braces _stmt_block      {char* s=malloc(sizeof(char)*(strlen($2)+strlen($3)+6)); strcpy(s,"IF "); strcat(s,$2); strcat(s, "\n"); strcat(s,$3); strcat(s,"\n"); $$ = s;}
                ;

_stmt_block:    OP_BEGIN _statement_list OP_END	        { char* s=malloc(sizeof(char)*(strlen($2)+10)); strcpy(s, "BEGIN\n"); strcat(s,$2); strcat(s,"\nEND"); $$ = s; }
                ;
                
_condition_list:    _condition_list _condition          { char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2)); strcpy(s, $1); strcat(s, "\n"); strcat(s, $2); $$ = s; }
                    | _condition                        { char* s=malloc(sizeof(char)*(strlen($1))); strcpy(s, $1); $$ = s;}
                    ;

_condition:     OP_WHEN _statement OP_THEN _statement  { char* s=malloc(sizeof(char)*(strlen($2)+strlen($4)+12)); strcpy(s,"WHEN "); strcat(s,$2); strcat(s," THEN "); strcat(s,$4); $$=s;}
                ;

_braces:        BRACE_OPEN BRACE_CLOSE { char* s=malloc(sizeof(char)*2); strcpy(s, "("); strcat(s, ")"); $$ = s;}                 
                | BRACE_OPEN _statement BRACE_CLOSE   { char* s=malloc(sizeof(char)*(strlen($2)+2)); strcpy(s, "("); strcat(s,$2); strcat(s,")"); $$ = s;}
                ;
%%

logYyText() {
    logMessage(yytext);
}

logMessage(const char* content) {
    printf("%s\r\n", content);
}

logkeyw(const char* content) {
    printf("<%s>\r\n", content);
}

yyerror(){
    fprintf(stderr,"Syntaxfehler! In Zeile: <%d>, Token: <%s> .\n", zeile, yytext);
}
int  main(){
    // set me to 1 to get nice debug messages!!!
    yydebug = 0;
    int fail = yyparse(); // returns a value of 0 if the input is valid to a given grammer

    if(!fail)

    	printf("<%d> Zeilen ohne Fehler überprüft !!! \n", zeile);

    return 0;
}
