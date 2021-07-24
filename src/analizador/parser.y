%defines "sintactico.h"
%output "sintactico.c"
%require "3.0.4"
%define parse.error verbose

/* Este codigo solo colocado en sintactico.c
   may define types and variables used in the actions */
%{
  /*-------------------------------------------------------------
   *                     %{  %}
   *-------------------------------------------------------------*/
  #include "lexico.h"//encabezado del analisis lexico  
  
  //-- Lexer prototype required by bison, aka getNextToken()
  extern int yylex(void); //del analizador lexico
  extern FILE* yyin;

  int yyerror(const char* mens);  
%}


%union{
  char * str;
  enum yytokentype tk;
  GString * gs;
  GSList * gsl;
}

%locations

/* La directiva es para colocar codigo que depende de YYSTYPE y
   YYLTYPE. Es colocado en sintactico.h y sintactico.c*/
%code requires {
  /*-------------------------------------------------------------
   *                      %code requires {  :D  }  
   *-------------------------------------------------------------*/
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <gmodule.h>  
  
  int analizar(char * source);
  void analizar_archivo(const char * path);
  void agregar_pedido(int tk, GString * contenido_header, GSList * etiquetas);
}

/* El codigo dentro de la directiva debe corresponder a definiciones y
   declaraciones adicionales que deben ser proporcionados por otros
   modulos.  Es colocado en sintactico.h y sintactico.c*/
%code provides {
  /*-------------------------------------------------------------
   *                      %code provides {  }
   *-------------------------------------------------------------*/  
  extern int yylineno;           //generada por flex a partir de scanner.l
  extern char *yytext;		 //generada por flex a partir de scanner.l

  const char * str_token(enum yytokentype tk);
}

/* El codigo dentro de esta directiva se ejecuta antes de que cada
   parsing yyparse() sea llamada. Este codigo solo colocado en sintactico.c*/
%initial-action
{
  /*-------------------------------------------------------------
   *                      %initial-action {  }
   *-------------------------------------------------------------*/
  
  //para usar el debug de bison. Ojo que ademas se debe usar '--debug' en el comando
// #ifdef YYDEBUG
//   yydebug = 1;
// #endif

   yylineno = 1;

   yylloc.first_line = yylloc.last_line=1;
   yylloc.first_column = yylloc.last_column=1;
   void cargar_clientes();
   cargar_clientes();
};


/* ==================================================
    't TERMINALES
   ==================================================*/
//sin tipo
%token H1 RPROPERTIES RCREATED RCLOSED REND;


//con tipo
%token <str> NUMERO;
%token <str> IDENTIFICADOR;
%token <tk> RTODO RDONE REMPA RNEXT;

/* ==================================================
    'nt NO TERMINALES
   ==================================================*/
%type<tk> Estado;
%type<str> Algo;
%type<gs> ContenidoHeader;
%type<gsl> Etiquetas;

%start Inicio
%%

Inicio
     : HeaderS
     | %empty
     ;

HeaderS
     : HeaderS Header
     | Header
     ;

Header
     : H1 Estado ContenidoHeader ':' Etiquetas
       ':' RPROPERTIES ':'
       ':' RCREATED ':' Fecha
       ':' REND ':'
       { agregar_pedido($2, $3, $5); }
     | H1 RDONE ContenidoHeader ':' Etiquetas
       RCLOSED ':' Fecha
       ':' RPROPERTIES ':'
       ':' RCREATED ':' Fecha
       ':' REND ':'
     ;

Fecha
     : '[' NUMERO '-' NUMERO '-' NUMERO IDENTIFICADOR NUMERO ':' NUMERO ']'
     ;

Etiquetas
     : Etiquetas IDENTIFICADOR ':'  { $$=g_slist_prepend($1, $2); }
     | IDENTIFICADOR ':'  { $$=g_slist_prepend(NULL, $1); }
     ;

Estado
     : RTODO  { $$ = $1; }
     | REMPA  { $$ = $1; }
     | RNEXT  { $$ = $1; }
     ;

ContenidoHeader
     : ContenidoHeader Algo {  $$ = g_string_append($1, $2);  g_free($2); }
     | Algo {  $$ = g_string_sized_new (100);  g_string_append($$, $1); g_free($1); }
     ;

Algo : IDENTIFICADOR  { $$ = g_strdup_printf(" %s", $1); }
     | ','	      { $$ = g_strdup_printf(","); }
     | '.'	      { $$ = g_strdup_printf("."); }
     | '/'            { $$ = g_strdup_printf("/"); }
     | NUMERO         { $$ = g_strdup_printf(" %s", $1); }
     ;
%%

int analizar(char * source) {
  YY_BUFFER_STATE buffer = yy_scan_string(source);
  int resp=yyparse();// Si nos da un número negativo, signifca error.
  yy_delete_buffer(buffer);
  return resp;
}

void analizar_archivo(const char * path) {
  yyin = fopen(path, "r"); // read mode

  if (yyin == NULL) {
     perror("Error mientras se abre archivo.\n");
     exit(EXIT_FAILURE);
  }

  do {
        yyparse();
  } while(!feof(yyin));   
}

int yyerror(const char* mens){
  printf("%d: lexema `%s´ %s\n", yylineno, yytext,mens);
  //printf("`%s´. %s\n",yytext,mens);
  return 0;
}

const char * str_token(enum yytokentype tk){
  return yytname[tk-255];
}

// Local Variables:
// mode: fundamental
// compile-command: "flex scanner.l & bison -v -l parser.y"
// End:
