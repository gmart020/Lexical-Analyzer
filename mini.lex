%{
#include <stdlib.h>
#include <math.h>

int lineNum = 1;
int colNum = 1;
%}

LETTER	[a-zA-Z]
DIGIT	[0-9]

%%

"function"		{printf("FUNCTION\n"); colNum += yyleng;}
"beginparams"	{printf("BEGIN_PARAMS\n"); colNum += yyleng;}
"endparams"		{printf("END_PARAMS\n"); colNum += yyleng;}
"beginlocals"	{printf("BEGIN_LOCALS\n"); colNum += yyleng;}
"endlocals"		{printf("END_LOCALS\n"); colNum += yyleng;}
"beginbody"		{printf("BEGIN_BODY\n"); colNum += yyleng;}
"endbody"		{printf("END_BODY\n"); colNum += yyleng;}
"integer"		{printf("INTEGER\n"); colNum += yyleng;}
"array"			{printf("ARRAY\n"); colNum += yyleng;}
"of"			{printf("OF\n"); colNum +=yyleng;}
"if"			{printf("IF\n"); colNum +=yyleng;}
"then"			{printf("THEN\n"); colNum +=yyleng;}
"endif"			{printf("ENDIF\n"); colNum +=yyleng;}
"else"			{printf("ELSE\n"); colNum +=yyleng;}
"while"			{printf("WHILE\n"); colNum +=yyleng;}
"do"			{printf("DO\n"); colNum +=yyleng;}
"foreach"		{printf("FOREACH\n"); colNum +=yyleng;}
"in"			{printf("IN\n"); colNum +=yyleng;}
"beginloop"		{printf("BEGINLOOP\n"); colNum +=yyleng;}
"endloop"		{printf("ENDLOOP\n"); colNum +=yyleng;}
"continue"		{printf("CONTINUE\n"); colNum +=yyleng;}
"read"			{printf("READ\n"); colNum +=yyleng;}
"write"			{printf("WRITE\n"); colNum +=yyleng;}
"and"			{printf("AND\n"); colNum +=yyleng;}
"or"			{printf("OR\n"); colNum +=yyleng;}
"not"			{printf("NOT\n"); colNum +=yyleng;}
"true"			{printf("TRUE\n"); colNum +=yyleng;}
"false"			{printf("FALSE\n"); colNum +=yyleng;}
"return"		{printf("RETURN\n"); colNum +=yyleng;}

"=="			{printf("EQ\n"); colNum +=yyleng;}
"<>"			{printf("NEQ\n"); colNum +=yyleng;}
"<"				{printf("LT\n"); colNum +=yyleng;}
">"				{printf("GT\n"); colNum +=yyleng;}
"<="			{printf("LTE\n"); colNum +=yyleng;}
">="			{printf("GTE\n"); colNum +=yyleng;}

"-"				{printf("SUB\n"); colNum +=yyleng;}
"+"				{printf("ADD\n"); colNum +=yyleng;}
"*"				{printf("MULT\n"); colNum +=yyleng;}
"/"				{printf("DIV\n"); colNum +=yyleng;}
"%"				{printf("MOD\n"); colNum +=yyleng;}

";"				{printf("SEMICOLON\n"); colNum +=yyleng;}
":"				{printf("COLON\n"); colNum +=yyleng;}
","				{printf("COMMA\n"); colNum +=yyleng;}
"("				{printf("L_PAREN\n"); colNum +=yyleng;}
")"				{printf("R_PAREN\n"); colNum +=yyleng;}
"["				{printf("L_SQUARE_BRACKET\n"); colNum +=yyleng;}
"]"				{printf("R_SQUARE_BRACKET\n"); colNum +=yyleng;}
":="			{printf("ASSIGN\n"); colNum +=yyleng;}

{DIGIT}+		{printf("NUMBER %d\n", atoi(yytext)); colNum += yyleng;}


{LETTER}+(("_")*({LETTER}|{DIGIT})+)*	{printf("IDENT %s\n", yytext); colNum += yyleng;}

[ \t]+	{colNum += yyleng;}

"\n"	{lineNum++; colNum = 1;}

"##"+([^\n]*)	/* Ignore the comments*/

({DIGIT}|"_")({DIGIT}|{LETTER}|"_")*	{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", lineNum, colNum, yytext); exit(0);}

{LETTER}({LETTER}|{DIGIT}|"_")*"_"+		{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", lineNum, colNum, yytext); exit(0);}

.		{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", lineNum, colNum, yytext); exit(0);}
%%

int main(int argc, char ** argv) {
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL) {
			yyin = stdin;
		}
	}
	else {
		yyin = stdin;
	}

	yylex();
}
