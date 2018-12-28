defmodule Mix.Tasks.Inch.Report do
  use Mix.Task

  @recursive true

  @doc false
  def run(_argv) do
    Mix.Task.run("compile")

    InchEx.CLI.main(["report"])
  end
end
