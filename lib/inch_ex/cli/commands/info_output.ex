defmodule InchEx.CLI.Commands.InfoOutput do
  alias InchEx.UI

  def call(info) do
    info
    |> basic_info()
    |> UI.puts()
  end

  defp basic_info(info) do
    """
    System:
      Inch: #{info["system"]["inch"]}
      Elixir: #{info["system"]["elixir"]}
      Erlang: #{info["system"]["erlang"]}
    """
    |> String.trim()
  end
end
