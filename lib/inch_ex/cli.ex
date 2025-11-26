defmodule InchEx.CLI do
  alias InchEx.CLI.Commands.ExplainCommand
  alias InchEx.CLI.Commands.InfoCommand
  alias InchEx.CLI.Commands.ReportCommand
  alias InchEx.CLI.Commands.SuggestCommand

  def main(argv) do
    InchEx.Application.start(nil, nil)

    argv
    |> determine_command()
    |> call_command()
  end

  defp determine_command(["info" | _] = argv) do
    {InfoCommand, argv}
  end

  defp determine_command(["report" | _] = argv) do
    {ReportCommand, argv}
  end

  defp determine_command(["explain" | _] = argv) do
    {ExplainCommand, argv}
  end

  defp determine_command([maybe_file_and_line_no] = argv) do
    if String.match?(maybe_file_and_line_no, ~r/\:\d+$/) do
      {ExplainCommand, argv}
    else
      {SuggestCommand, argv}
    end
  end

  defp determine_command(argv) do
    {SuggestCommand, argv}
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
