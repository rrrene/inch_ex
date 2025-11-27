defmodule InchEx do
  @version Mix.Project.config()[:version]

  alias InchEx.CodeObject
  alias InchEx.Docs

  @doc "Returns the version of Inch."
  def version, do: @version

  @doc false
  def get_and_eval_docs(path) do
    Docs.beam_files(path, fn beam_file ->
      beam_file
      |> Docs.get_docs()
      |> CodeObject.eval()
    end)
  end
end
