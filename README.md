# lua-vte-example

Este repositorio contiene un pequeño ejemplo de cómo usar VTE con LGI en Lua y crear una ventana de terminal simple.

__¿Cómo funciona?__

Si bien prácticamente todo el código está comentado lo más detalladamente posible, en resumen lo que hace el fichero `main.lua` es cargar una plantilla XML interfaz de usuario creada con Glade para crear toda la interfaz, crear una instancia de `VteTerminal`, colocarla en un contenedor de Gtk, conectar varias señales de Gtk y VTE a funciones y finalmente mostrar el resultado final.

__Limitaciones__

La idea original era que el script sea capaz de crear la ventana con la terminal y además que al presionar un botón se pudieran agregar pestañas con otras instancias de VTE. Sin embargo, por alguna razón, luego de varios intentos no pude lograrlo con éxito y lo único que sucedía era que la ventana se congelaba y no respondía de ninguna manera y luego pasados unos segundos, se rompía el programa haciendo que el sistema retornaba un error `SIGSEV` o algo similar.

También, con la función `vte_terminal_spawn_async()` parece no funcionar correctamente con LGI.

__Requisitos__

Para ejecutar `main.lua`, solo necesitarás Lua 5.1 en adelante, [LGI](https://github.com/pavouk/lgi) y Vte.
