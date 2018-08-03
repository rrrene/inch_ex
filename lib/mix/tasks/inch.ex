defmodule Mix.Tasks.Inch do
  use Mix.Task

  @shortdoc "Show documentation evaluation for the project"
  @recursive true

  @doc false
  def run(argv) do
    InchEx.CLI.main(argv)
  end
end
