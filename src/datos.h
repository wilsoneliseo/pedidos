#ifndef DATOS_H
#define DATOS_H

#include <gmodule.h>

GHashTable *clientes = NULL;

void           
agregar_pedido(int tk, GString * contenido_header, GSList * etiquetas);


void
g_string_replace (GString *string, const gchar *find, const gchar *replace);

void
cargar_clientes();

#endif
