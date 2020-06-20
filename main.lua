-- Cargamos las librerías necesarias
local lgi  = require("lgi")
local Gtk  = lgi.Gtk
local Vte  = lgi.Vte
local GLib = lgi.GLib

-- Cargamos el archivo de interfaz de usuario
local builder = Gtk.Builder()
builder:add_from_file("vte.glade")

-- Creamos nuestra aplicación y nuestro VteTerminal
local ui   = builder.objects
local app  = Gtk.Application()
local term = Vte.Terminal({ -- Puedes modificar esto según tus gustos
  allow_bold = true, -- Permite texto en negrita
  allow_hyperlink = true, -- Permite hipervínculos
  audible_bell = true, -- Permite campana audible
  scroll_on_keystroke = true, -- Hace "scroll" si el usuario presiona alguna tecla
  cursor_shape = Vte.CursorShape.IBEAM -- Tipo de cursor
})

-- Cierra la aplicación al finalizar el programa hijo
function term:on_child_exited(status, data)
  app:quit()
end

function app:on_activate(data)
  -- Puedes modificar esto según tus gustos
  local termFont = term:get_font() -- Obtiene un "PangoFontDescription"
  termFont:set_family("Cascadia Code") -- Cambia la familia de fuentes
  termFont:set_size(termFont:get_size() * 1.1) -- Cambia el tamaño de la fuente

  -- "spawnea" la shell en el VteTerminal. Por favor, véase la documentación para más detalles
  term:spawn_sync(
    -- "flags" específicos de Vte
    Vte.PtyFlags.DEFAULT,
    -- "working_directory", la carpeta en la que trabajará nuestra shell, puede dejarse en nil
    os.getenv("HOME"),
    -- "argv", si no me equivoco, se refiere al programa que vamos a mostrar y sus argumentos
    { os.getenv("SHELL") },
    -- "envv", variables de entorno para pasar a nuestro programa, lo dejo en nil para no alterar nada en la shell
    nil,
    -- "flags" para g_spawn_...()
    GLib.SpawnFlags.DEFAULT,
    -- "child_setup", una función que se ejecuta justo antes que nuestro proceso hijo
    function() end
  )
  -- vte_terminal_new() retorna un GtkWidget* y necesitamos mostrarlo debido a que se está usando el método
  -- present() (gtk_window_present()) en la ventana de la aplicación, de lo contrario no se mostraría.
  term:show()

  -- Añadimos nuestro VteTerminal a la vista scrollable
  ui.scroll:add(term)
  -- Si usamos ui.win:show_all(), no será necesaria la línea: term:show()
  ui.win:present()

  -- Añadimos la ventana a nuestra aplicación
  self:add_window(ui.win)
end

-- Y corremos la aplicación
app:run()