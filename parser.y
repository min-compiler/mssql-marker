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
    char cval;
}

%left OP_CASE OP_WHEN OP_THEN OP_ELSE OP_END OP_IF OP_BEGIN OP_TRY OP_CATCH OP_GOTO OP_RETURN OP_WHILE OP_DELAY OP_TIME OP_WAITFOR OP_BREAK OP_CONTINUE OP_THROW OP_DECLARE OP_EXECUTE OP_PRINT OP_RAISEERROR BRACE_OPEN BRACE_CLOSE CONTENT

%%

_statement_list: _statement_list _statement
                | _statement
                ;
                
_statement:     _content_word           { logMessage("contentWord"); }
                | _operation            { logMessage("operation"); }
                ;
                
_content_word:  _content_word CONTENT
                | CONTENT               { logMessage("content"); logMessage(yytext); }
                ;
                
_operation:     _while _statement
                | _case
                ;
                
_while:         OP_WHILE                { logMessage(yytext); }
                ;
                
_case:          OP_CASE _condition_list OP_END                                  { logMessage("case"); }
                | OP_CASE _condition_list _condition_else OP_END                { logMessage("caseElse"); }
                | OP_CASE _statement _condition_list OP_END                     { logMessage("case"); }
                | OP_CASE _statement _condition_list _condition_else OP_END     { logMessage("caseElse"); }
                ;

_condition_list:    _condition_list _condition
                    | _condition;

_condition:     OP_WHEN _statement OP_THEN _statement;  

_condition_else:     OP_ELSE _statement;  



                
%%

logYyText() {
    logMessage(yytext);
}

logMessage(const char* content) {
    printf("%s\r\n", content);
}

yyerror(){
    fprintf(stderr,"Syntaxfehler!\n");
}
main(){
    // set me to 1 to get nice debug messages!!!
    yydebug = 0;
    yyparse();
}
