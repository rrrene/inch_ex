defmodule InchEx.CLI do
  alias InchEx.CLI.Commands.SuggestCommand
  alias InchEx.CLI.Commands.ExplainCommand

  def main(argv) do
    InchEx.Application.start(nil, nil)

    argv
    |> determine_command()
    |> call_command()
  end

  defp determine_command([]) do
    {SuggestCommand, []}
  end

  defp determine_command([maybe_file_and_line_no] = argv) do
    if String.match?(maybe_file_and_line_no, ~r/\:\d+$/) do
      {ExplainCommand, argv}
    else
      {SuggestCommand, argv}
    end
  end

  defp call_command({command, argv}) do
    command.call(argv)
  end

  def term_columns(default \\ 80) do
    case :io.columns() do
      {:ok, columns} -> columns
      _ -> default
    end
  end
end
