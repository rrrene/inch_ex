defmodule InchEx.JSON do
  @moduledoc false

  @doc false
  def encode!(v), do: Jason.encode!(v, pretty: true)

  defmodule Mapping do
    @moduledoc false

    @doc false
    def from_results(results, base \\ %{}) do
      Map.put(base, "results", Enum.map(results, &to_json/1))
    end

    defp to_json(result) do
      base = Map.drop(result, ["roles", "metadata"])
      roles = Enum.map(result["roles"], &listify/1)

      Map.put(base, "roles", roles)
    end

    defp listify(tuple) when is_tuple(tuple) do
      tuple
      |> Tuple.to_list()
      |> Enum.map(&listify/1)
    end

    defp listify(value), do: value
  end
end
