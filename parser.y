/*
parser.y:
*/

%{

#include<stdio.h>
#include<math.h>
int zeile=1;

extern char *yytext;
double symbole[26];

%}

%union {
    double dval;
    int ival;
    char cval;
}

%left OP_LABEL OP_CASE OP_WHEN OP_THEN OP_END OP_IF OP_BEGIN OP_CATCH OP_WHILE BRACE_OPEN BRACE_CLOSE 
%right CONTENT
%nonassoc PSEUDO_THEN
%nonassoc OP_ELSE
%%

_statement_list: _statement_list _statement
                | _statement
                ;
                
_statement:     _content_word                   { logMessage("contentWord"); }          
                | _operation                    { logMessage("operation"); }
                ;
                
_content_word:  CONTENT _content_word
                | CONTENT                                                       { logMessage("content"); logMessage(yytext); }     
                | CONTENT BRACE_OPEN BRACE_CLOSE _content_word
                | CONTENT BRACE_OPEN _content_word BRACE_CLOSE _content_word 
                | CONTENT BRACE_OPEN BRACE_CLOSE  
                | CONTENT BRACE_OPEN _content_word BRACE_CLOSE             
                ;

_braces:        BRACE_OPEN BRACE_CLOSE                  
                | BRACE_OPEN _statement BRACE_CLOSE    
                ;
                
_operation:     _while _statement
                | _case
                | _label
                | _catch
		| _if
                ;
                
_while:         OP_WHILE                { logMessage(yytext); }
                ;
                

_label:         OP_LABEL                { logMessage(yytext); }

_case:          OP_CASE _condition_list OP_END                                  { logMessage("case"); }
                | OP_CASE _condition_list _condition_else OP_END                { logMessage("caseElse"); }
                | OP_CASE _statement _condition_list OP_END                     { logMessage("case"); }
                | OP_CASE _statement _condition_list _condition_else OP_END     { logMessage("caseElse"); }
                ;

_condition_list:    _condition_list _condition
                    | _condition;

_condition:     OP_WHEN _statement OP_THEN _statement;  

_condition_else:     OP_ELSE _statement;  

_catch:         OP_CATCH _statement OP_END OP_CATCH     { logMessage("catch"); }
                ;


_if:    _if_then %prec PSEUDO_THEN                              { logMessage("if"); }
	| _if_then OP_ELSE _stmt_block 				{ logMessage("if else"); }
	;

_if_then:       OP_IF _braces _stmt_block
		;

_stmt_block:	OP_BEGIN _statement_list OP_END	        { logMessage("block"); }
		;
%%

logYyText() {
    logMessage(yytext);
}

logMessage(const char* content) {
    printf("%s\r\n", content);
}

yyerror(){
    fprintf(stderr,"Syntaxfehler! In Zeile: %d .\n", zeile);
}
main(){
    // set me to 1 to get nice debug messages!!!
    yydebug = 0;
    yyparse();
}
