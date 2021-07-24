#include"analizador/sintactico.h"
#include<global.h>

GHashTable *clientes = NULL;

int
main(int argc, char **argv) {
  if(argc != 2){
    printf("Use: pedidos <ARCHIVO>\n");
    return 1;
  }

  analizar_archivo(argv[1]);
  
  return 0; 
}

/* Local Variables: */
/* compile-command: "make -C ../bin/" */
/* End: */
