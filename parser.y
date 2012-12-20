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


%left <cval> OP_CASE OP_WHEN OP_THEN OP_ELSE OP_END OP_IF OP_BEGIN OP_TRY OP_CATCH OP_GOTO OP_RETURN OP_WHILE OP_DELAY OP_TIME OP_WAITFOR OP_BREAK OP_CONTINUE OP_THROW OP_DECLARE OP_EXECUTE OP_PRINT OP_RAISEERROR BRACE_OPEN BRACE_CLOSE CONTENT

%%

_statement_list: _statement_list _statement
                | _statement
                ;
                
_statement:     _content_word
                | _operation
                ;
                
_content_word:  CONTENT _content_word
                | CONTENT               { logMessage(yytext); }
                ;
                
_operation:     _operator _statement
                ;

_operator:      _while 
                | _case
                ;
                
_while:         OP_WHILE                { logMessage(yytext); }
                ;

_case:          OP_CASE                 { logMessage(yytext); }
                ;
                


                
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
    yyparse();
}
