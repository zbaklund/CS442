Letter	[A-Za-z]
Digit   [0-9]

%{
  #include "IOMngr.h"
  #include "YSemantics.h"
  #include "y.tab.h"

  #define YY_INPUT(buf,result,max_size) \
  { int c = GetSourceChar(); \
		result = (c == EOF) ? YY_NULL : (buf[0] = c, 1); \
  }

  // Set to true to log each token returned to stderr
  bool shouldLog = false;

  // The column of the returned token's first char
  unsigned int tokenStartPosition;

  // Return token number
  // offset = 1 for tokens that include the last char read
  // offset = 0 for tokens that do not include the last char read
  // also computes and sets span of token
  #define RETURN(val,offset) \
  { if (shouldLog) fprintf(stderr,"Token#=%d, Length=%zu, Text=\"%s\"\n",val,(unsigned long)yyleng,yytext); \
    tokenStartPosition = GetLastPosition() - yyleng + offset; \
    yylloc.first_column = tokenStartPosition; \
    yylloc.last_column = yylloc.first_column + yyleng - 1; \
    return(val); \
  }

  // comment implementation
  int commentLevel = 0;
  int lineComment = false;
  #define IN_COMMENT ( lineComment || commentLevel > 0)
%}

%%
int                             { if ( !IN_COMMENT ) RETURN( INT_TOK, 1 ); }
chr                             { if ( !IN_COMMENT ) RETURN( CHR_TOK, 1 ); }
bool                            { if ( !IN_COMMENT ) RETURN( BOOL_TOK, 1 ); }
void                            { if ( !IN_COMMENT ) RETURN( VOID_TOK, 1 ); }
true                            { if ( !IN_COMMENT ) RETURN( BOOLLIT_TOK, 1 ); }
false                           { if ( !IN_COMMENT ) RETURN( BOOLLIT_TOK, 1 ); }
put                             { if ( !IN_COMMENT ) RETURN( PUT_TOK, 1 ); }
get                             { if ( !IN_COMMENT ) RETURN( GET_TOK, 1 ); }
if                              { if ( !IN_COMMENT ) RETURN( IF_TOK, 1 ); }
else                            { if ( !IN_COMMENT ) RETURN( ELSE_TOK, 1 ); }
while                           { if ( !IN_COMMENT ) RETURN( WHILE_TOK, 1 ); }
for                             { if ( !IN_COMMENT ) RETURN( FOR_TOK, 1 ); }
switch                          { if ( !IN_COMMENT ) RETURN( SWITCH_TOK, 1); }
break                           { if ( !IN_COMMENT ) RETURN( BREAK_TOK, 1); }
case                            { if ( !IN_COMMENT ) RETURN( CASE_TOK, 1); }
-?{Digit}+                      { if ( !IN_COMMENT ) RETURN( INTLIT_TOK, 0 ); }
{Letter}({Letter}|{Digit})*			{ if ( !IN_COMMENT ) RETURN( IDENT_TOK, 0 ); }
\'\\.\'                         { if ( !IN_COMMENT ) RETURN( CHRLIT_TOK, 1 ); }
\'.\'                           { if ( !IN_COMMENT ) RETURN( CHRLIT_TOK, 1 ); }
\"(\\.|[^"\\])*\"               { if ( !IN_COMMENT ) RETURN( STRLIT_TOK, 1 ); }
\:\:                            { if ( !IN_COMMENT ) RETURN( DBLCOLON_TOK, 1 ); }
\-\>                            { if ( !IN_COMMENT ) RETURN( ARROW_TOK, 1 ); }
\:                              { if ( !IN_COMMENT ) RETURN( ':', 1 ); }
\,                              { if ( !IN_COMMENT ) RETURN( ',', 1 ); }
\{                              { if ( !IN_COMMENT ) RETURN( '{', 1 ); }
\}                              { if ( !IN_COMMENT ) RETURN( '}', 1 ); }
\(                              { if ( !IN_COMMENT ) RETURN( '(', 1 ); }
\)                              { if ( !IN_COMMENT ) RETURN( ')', 1 ); }
\=                              { if ( !IN_COMMENT ) RETURN( '=', 1 ); }
\>                              { if ( !IN_COMMENT ) RETURN( '>', 1 ); }
\<                              { if ( !IN_COMMENT ) RETURN( '<', 1 ); }
\#                              { if ( !IN_COMMENT ) RETURN( '#', 1 ); }
\+                              { if ( !IN_COMMENT ) RETURN( '+', 1 ); }
\-                              { if ( !IN_COMMENT ) RETURN( '-', 1 ); }
\*                              { if ( !IN_COMMENT ) RETURN( '*', 1 ); }
\/                              { if ( !IN_COMMENT ) RETURN( '/', 1 ); }
[ \t]                           { }
\/\/                            { lineComment = true; }
\/\*                            { commentLevel += 1; }
\*\/                            { commentLevel -= 1; }
[\n]                            { lineComment = false; }
.                               { }
%%
