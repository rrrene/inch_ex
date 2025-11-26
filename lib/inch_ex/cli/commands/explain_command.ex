defmodule InchEx.CLI.Commands.ExplainCommand do
  alias InchEx.CLI.Options
  alias InchEx.CodeObject
  alias InchEx.Docs

  alias InchEx.CLI.Commands.ExplainOutput

  @doc false
  def call(["explain" | argv]) do
    call(argv)
  end

  def call([]) do
    nil
  end

  def call(argv) do
    argv
    |> locate_docs()
    |> fetch_and_evaluate_docs()
    |> display_results(argv)
  end

  defp locate_docs(argv) do
    options = Options.parse(argv)

    Docs.beam_files(options.path)
  end

  defp fetch_and_evaluate_docs(beam_files) when is_list(beam_files) do
    beam_files
    |> Enum.map(&Task.async(fn -> fetch_and_evaluate_docs(&1) end))
    |> Enum.flat_map(&Task.await(&1, :infinity))
  end

  defp fetch_and_evaluate_docs(beam_file) when is_binary(beam_file) do
    beam_file
    |> Docs.get_docs()
    |> CodeObject.eval()
  end

  defp display_results(results, []) do
    display_results(results, [nil])
  end

  defp display_results(results, [first_arg | _]) do
    results
    |> Enum.filter(fn item -> item["location"] == first_arg || item["name"] == first_arg end)
    |> ExplainOutput.call()
  end
end
