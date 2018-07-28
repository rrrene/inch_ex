# Original code adapted from ExDoc

defmodule Mix.Tasks.Inch do
  use Mix.Task

  @shortdoc "Show documentation evaluation for the project"
  @recursive true

  @doc false
  def run(argv) do
    InchEx.CLI.main(argv)
  end

  # path = Mix.Project.compile_path()
  # files = Docs.beam_files(path)
  # docs = Docs.get_docs(files)

  # IO.puts(List.last(files))

  # file =
  #   "/Users/rene/projects/inch_ex/_build/dev/lib/inch_ex/ebin/Elixir.InchEx.CodeObject.beam"

  # module_name =
  #   file
  #   |> Path.basename()
  #   |> String.replace(~r/^Elixir\./, "")
  #   |> String.replace(~r/\.beam$/, "")

  # IO.puts(module_name)
  # IO.puts("")
  # IO.inspect(docs)
end
