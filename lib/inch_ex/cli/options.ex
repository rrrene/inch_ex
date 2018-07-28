defmodule InchEx.CLI.Options do
  defstruct path: nil

  def parse(_argv) do
    %__MODULE__{
      path: Mix.Project.compile_path()
    }
  end
end
