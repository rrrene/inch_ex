defmodule InchEx.CLI.Commands.SuggestCommand do
  alias InchEx.CLI.Options

  alias InchEx.CLI.Commands.SuggestOutput

  @doc false
  def call(argv) do
    options = Options.parse(argv)

    options.path
    |> InchEx.get_and_eval_docs()
    |> display_results(options)
  end

  defp display_results(results, options) do
    SuggestOutput.call(results, options)
  end
end
