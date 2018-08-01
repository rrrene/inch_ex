defmodule InchEx.CLI.Commands.InfoCommand do
  alias InchEx.CLI.Commands.InfoOutput

  @shortdoc "Show useful debug information"
  @moduledoc @shortdoc

  @doc false
  def call(_argv) do
    InfoOutput.call(info())
  end

  defp info() do
    %{
      "system" => %{
        "inch" => InchEx.version(),
        "elixir" => System.version(),
        "erlang" => System.otp_release()
      }
    }
  end
end
