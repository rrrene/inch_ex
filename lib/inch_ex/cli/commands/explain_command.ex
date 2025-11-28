defmodule InchEx.CLI.Commands.ExplainCommand do
  alias InchEx.CLI.Commands.ExplainOutput

  @doc false
  def call(["explain" | argv]) do
    call(argv)
  end

  def call([]) do
    nil
  end

  def call(argv) do
    InchEx.get_evaluated_docs()
    |> display_results(argv)
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
