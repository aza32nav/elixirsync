defmodule Elixirsync do
  @moduledoc """
  # Elixirsync Program.

  Execute a rsync command with a file.

  ## File Content:
    - Origin:       /home/user/
    - Destination   /media/user/usb/
    - Folders       Download/
                    Documents/
                    Music/

  ## Execute a command shell

  Metodos para ejecutar comando en shell

  ### Con Erlang os:cmd().
  :os.cmd(String.to_char_list("ls -l"))
  "ls -l" |> String.to_char_list |> :os.cmd

  ### Elixir
  System.cmd("ls", ["-l"], into: IO.stream(:stdio, :line))
  """

  @doc """
  Funcion principal del programa
    - Agregar tests
    - Verificar la configuracion del archivo
    - modularizar
    - refactorizar
    - probar con sqlite, barrel, couchDb, datomic
    - Experimentar con protocolos y structs
  """
  def main(argv) do
    param = parse_args(argv)
    if is_binary(param)  do
      param
      |> split_file()
      |> create_commands()
    end
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    case parse do
      {[help: true], _, _} -> display_help()
      {_, [str], _} -> str
      _ -> display_help()
    end
  end

  defp display_help do
    IO.puts("------------------------------------------------------------------------")
    IO.puts("Comando     Argumento")
    IO.puts("./elixirsync Home_Ext")
    IO.puts("------------------------------------------------------------------------")
    IO.puts(" Para la correcta ejecucion del programa hay que escribir su comando")
    IO.puts(" seguido del nombre del Archivo que contiene los directorios a respaldar")
    IO.puts(" guardado en el mismo directorio")
  end

  @doc """
  Función para separa el archivo en origin, destination y folders
  Con un archivo con contenido:
  /home/user/
  /media/user/usb/
  Descargas/
  Documentos/

  La Funcion retorna una tupla:
  { String,       String,             List[String]}
  { origin,       destination,        folders}
  {"/home/user/", "/media/user/usb/", ["Descargas/", "Documentos/"]}
  """
  def split_file(name_file) do
    case File.read(name_file) do
      {:ok, file} ->
        file_list = file |> String.trim |> String.split("\n")
        origin = hd(file_list)
        destination = hd(tl(file_list))
        folders = tl(tl(file_list))
        {origin, destination, folders}
      {:error, reason} ->
        IO.puts "------------------------------------------------------------"
        IO.puts "Error"
        IO.puts reason
        IO.puts "------------------------------------------------------------"
        IO.puts "El Archivo no existe favor de crearlo o revisar su nombre en"
        IO.puts "la carpeta resources"
    end


  end

  @doc """
  Funcion para mostrar el comando en pantalla.
  Argumentos:
  String, String, String
  """
  def display_command(origin, destination, folder) do
    "\nrsync -rtvu --delete " <> origin <> folder <> " " <> destination <> folder 
  end

  @doc """
  Funcion que ejecuta el comando con tres parametros:
  String, String,      String
  origin, destination, folder
  """
  def exec_cmd(origin, destination, folder) do
    or_complete = origin <> folder
    des_complete = destination <> folder
    System.cmd("rsync", ["-rtvu", "--delete", or_complete, des_complete], into: IO.stream(:stdio, :line))
  end

  @doc """
  Funcion que toma la tupla del tipo {origin, destination, folders} para
  conformar, mostrar y  ejecutar los comandos con cada unas de las carpetas
  Argumento:
  Tuple
  """
  def create_commands(info_dirs) do
    {origin, destination, folders} = info_dirs
    create_cmd(origin, destination, folders)
  end

  #Funcion para mostrar y ejecutar el comando de rsync con cada una de las carpetas
  #Argumentos:
  #String, String, [String]
  defp create_cmd(_origin, _destination, []), do: IO.puts "\nLa ejecucion de los comandos a terminado"
  defp create_cmd(origin, destination, folders) do
    if hd(folders) == ""  do
      create_cmd(origin, destination, tl(folders))
    else
      IO.puts display_command(origin, destination, hd(folders))
      exec_cmd(origin, destination, hd(folders))
      create_cmd(origin, destination, tl(folders))
    end
  end

end
