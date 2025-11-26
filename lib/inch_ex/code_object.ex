defmodule InchEx.CodeObject do
  @moduledoc """
  This module provides functions to deal with code objects.
  """

  @doc """
  Evaluates the given `list` of code objects.
  """
  @doc since: "2.0.0"
  def eval(list) when is_list(list) do
    cast_list =
      list
      |> Enum.map(&cast/1)
      |> Enum.reject(&is_nil/1)

    cast_list
    |> Enum.map(&prepare(&1, cast_list))
    |> Enum.map(&transform/1)
  end

  # Ignore files without docs chunk
  def eval(nil), do: []

  @doc "Injects additional attributes into the given map"
  def cast(item)

  def cast(%{"doc" => false}), do: nil

  def cast(item) do
    Map.merge(%{"name" => item["name"] || item["id"], "metadata" => %{}}, item)
  end

  defp prepare(item, list) do
    Map.put(item, "children", children(item, list))
  end

  defp transform(item) do
    {roles, score, grade, priority} = evaluate(item)

    %{
      "name" => item["name"],
      "location" => item["location"],
      "type" => item["type"],
      "metadata" => Map.drop(item["metadata"], ignored_metadata_keys()),
      "doc" => item["doc"],
      "score" => score,
      "grade" => grade,
      "priority" => priority,
      "roles" => roles
    }
  end

  defp evaluate(item) do
    roles = InchEx.CodeObject.Roles.run(item)
    score = InchEx.CodeObject.Score.run(roles, item["type"])
    priority = InchEx.CodeObject.Priority.run(roles, item["type"])
    grade = InchEx.CodeObject.Grade.run(score)

    {roles, score, grade, priority}
  end

  defp children(%{"name" => name}, list) do
    count =
      list
      |> Enum.filter(&String.starts_with?(&1["name"], name))
      |> Enum.count()

    count - 1
  end

  @doc false
  def ignored_metadata_keys do
    [:behaviours, :defaults, :delegate_to, :source_annos, :source_path]
  end
end
