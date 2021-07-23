%option outfile="lexico.c" header-file="lexico.h"
%option noyywrap
%option nounput

/* este bloque es colocado en lexico.c no en lexico.h */
%{
   #include "sintactico.h"//encabezado del analisis sintactica

   static void actualizar_linea_columna();
   static void copiar_str();
   static void eliminar_comillas();
%}

%option yylineno

letra        [a-zA-ZñÑáéíóúÁÉÍÓÚ]
digito       [0-9]
blanco       [ \t]
simbolo      "["|"]"|","|":"|"-"|"."|"/"

id           ({letra}|"_")({letra}|{digito}|"_")*

numero       [0-9]+("."[0-9]+)?

%x COMENTARIO_LINEA

%%
<INITIAL>{
  "#"         {  BEGIN (COMENTARIO_LINEA); }
  ^"*"        {  return H1;  }
  {simbolo}   {  return yytext[0];  }
  TODO        {  yylval.tk = RTODO; return RTODO; }
  DONE        {  yylval.tk = RDONE; return RDONE; }
  EMPA        {  yylval.tk = REMPA; return REMPA; }
  NEXT        {  yylval.tk = RNEXT; return RNEXT; }
  PROPERTIES  {  return RPROPERTIES;  }
  CREATED     {  return RCREATED;  }
  CLOSED      {  return RCLOSED;  }
  END         {  return REND;  }
  "\n"	      {  ;  }
  {numero}    {  copiar_str(); return NUMERO; }
  {id}        {  copiar_str();   return IDENTIFICADOR;  }
  {blanco}    {  ;  }
  .	      {  	         
		 printf("%d: Caracter desconocido `%c´.\n", yylineno, yytext[0]);
	      }
}

<COMENTARIO_LINEA>{
  "\n"                   {  BEGIN(INITIAL); }
  .
}

%%

static void copiar_str(){
  yylval.str=strdup(yytext);
}

static void eliminar_comillas(){
  size_t bytes_bloque=strlen(yytext)-2;
  memmove(yytext+0, yytext+1, bytes_bloque);
  yytext[bytes_bloque]='\0';
}

// Local Variables:
// mode: c
// compile-command: "flex scanner.l & bison -v -l parser.y"
// End:
