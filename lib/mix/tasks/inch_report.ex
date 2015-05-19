defmodule Mix.Tasks.Inch.Report do
  use Mix.Task

  @recursive true

  @doc false
  def run(_, config \\ Mix.Project.config, generator \\ &InchEx.generate_docs/4, reporter \\ InchEx.Reporter.Remote) do
    Mix.Tasks.Inch.run([], config, generator, reporter)
  end
end
