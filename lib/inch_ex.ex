defmodule InchEx do
  @version Mix.Project.config()[:version]

  alias InchEx.CodeObject
  alias InchEx.Docs

  @doc "Returns the version of Inch."
  def version, do: @version

  @doc false
  def get_evaluated_docs() do
    Docs.beam_files(Mix.Project.compile_path(), fn beam_file ->
      beam_file
      |> Docs.get_docs()
      |> CodeObject.eval()
    end)
  end

  @doc false
  def get_evaluated_docs("" <> name) do
    Enum.find(get_evaluated_docs(), &(&1["name"] == name))
  end
end
