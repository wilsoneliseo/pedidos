#include "datos.h"
#include<analizador/sintactico.h>

void
agregar_pedido(int tk, GString * contenido_header, GSList * etiquetas) {
  if(tk == RTODO) {
    g_string_replace(contenido_header, "/ ", "/");

    for (GSList * iterador = etiquetas; iterador; iterador = iterador->next) {
      printf("%s:", (const char *)iterador->data);
    }  

    printf("%s\n", contenido_header->str);
  }else{
    g_string_free(contenido_header,TRUE);  
  }
}

void
g_string_replace (GString *string, const gchar *find, const gchar *replace){
    char **split = g_strsplit(string->str, find, 0); /* 0 para que replace todas las ocurrencias */
    g_string_assign(string, g_strjoinv(replace, split) );
    g_strfreev(split);		  
}


void
cargar_clientes(){
  clientes = g_hash_table_new(g_str_hash, g_str_equal);

  g_hash_table_insert(clientes, "juanasp", NULL);
  g_hash_table_insert(clientes, "chet", NULL);
  g_hash_table_insert(clientes, "elena", NULL);
  g_hash_table_insert(clientes, "francisca", NULL);
  g_hash_table_insert(clientes, "celestina", NULL);
  g_hash_table_insert(clientes, "diana", NULL);
  g_hash_table_insert(clientes, "flori", NULL);
  g_hash_table_insert(clientes, "carolina", NULL);
  g_hash_table_insert(clientes, "mariamontufar", NULL);
  g_hash_table_insert(clientes, "rosatoto", NULL);
  g_hash_table_insert(clientes, "doris", NULL);
  g_hash_table_insert(clientes, "rolando", NULL);
  g_hash_table_insert(clientes, "marina", NULL);
  g_hash_table_insert(clientes, "fernanda", NULL);
  g_hash_table_insert(clientes, "delfina", NULL);
  g_hash_table_insert(clientes, "claudia", NULL);
  g_hash_table_insert(clientes, "edgar", NULL);
  g_hash_table_insert(clientes, "baten", NULL);
  g_hash_table_insert(clientes, "adela", NULL);
  g_hash_table_insert(clientes, "tujal", NULL);
  g_hash_table_insert(clientes, "cristina", NULL);
  g_hash_table_insert(clientes, "elvis", NULL);
  
}
