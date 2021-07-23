#include"analizador/sintactico.h"

/* int main(int argc, char **argv) */
int
main(int argc, char **argv) {
  if(argc != 2){
    printf("Use: pedidos <ARCHIVO>\n");
    return 1;
  }

  /* printf("%s\n",argv[1]); */

  analizar_archivo(argv[1]);

  /*char * entrada = "* DONE Luto,celeste,azul :celestina:gesat:\nCLOSED: [2021-07-06 Tue 16:47]\n:PROPERTIES:\n:CREATED:  [2021-06-16 Wed 09:37]\n:END:";
  int hay_error = analizar(entrada);

  if(hay_error)
    printf("Huvo error.\n");    
  else
  printf("Analisis exitoso.\n");*/
  
  return 0; 
}

/* Local Variables: */
/* compile-command: "make -C ../bin/" */
/* End: */
