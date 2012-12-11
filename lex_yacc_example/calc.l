/*
*   calc.l
*   Lexikalische Analyse fuerer weiterten Taschenrechner
*/

%{
#include "calc.tab.h"
#include <ctype.h>
%}
Ziffer[0-9]
Zahl({Ziffer}+".")?{Ziffer}+
delim[ \t]
%%
{delim}     {/*nothing*/}
\n          {return (NL);}
"+"         {return (ADD);}
"-"         {return (SUB);}
"*"         {return (MUL);}
"/"        {return (DIV);}
"("         {return (KLAMMERAUF);}
")"         {return (KLAMMERZU);}
"="         {return (ASSIGNOP);}
{Zahl}      {yylval.dval = atof(yytext);
            /*Uebergabe des numerischen Werts*/
            return(ZAHL);}

[a-zA-Z]    {if(isupper(yytext[0]))
                yylval.ival = yytext[0] - 'A';
            else
                yylval.ival = yytext[0] - 'a';
            return (ID);}

.           {return yytext[0];}
%%
yywrap(){}

