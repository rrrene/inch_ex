defmodule InchEx.CodeObject do
  @moduledoc """
  This module provides functions to deal with code objects.
  """

  @doc """
  Evaluates the given `list` of code objects.
  """
  @doc since: "2.0.0"
  def eval(list) when is_list(list) do
    list =
      list
      |> Enum.map(&cast/1)
      |> Enum.reject(&is_nil/1)

    list
    |> Enum.map(&prepare(&1, list))
    |> Enum.map(&transform/1)
  end

  @doc "Injects additional attributes into the given map"
  def cast(item)

  def cast(%{"doc" => false}), do: nil

  def cast(item), do: item

  def prepare(item, list) do
    item
    |> Map.put("children", children(item, list))
  end

  def transform(item) do
    {roles, score, grade, priority} = evaluate(item)

    %{
      "name" => item["name"],
      "location" => item["location"],
      "type" => item["type"],
      "metadata" => item["metadata"],
      "doc" => item["doc"],
      "score" => score,
      "grade" => grade,
      "priority" => priority,
      "roles" => roles
    }
  end

  def evaluate(item) do
    roles = InchEx.CodeObject.Roles.run(item)
    score = InchEx.CodeObject.Score.run(roles, item["type"])
    priority = InchEx.CodeObject.Priority.run(roles, item["type"])
    grade = InchEx.CodeObject.Grade.run(score)

    {roles, score, grade, priority}
  end

  def name(%{"module_id" => module_id, "id" => id}), do: "#{module_id}.#{id}"
  def name(%{"id" => id}) when is_binary(id), do: id

  def children(%{"name" => name}, list) do
    count =
      list
      |> Enum.filter(&String.starts_with?(&1["name"], name))
      |> Enum.count()

    count - 1
  end
end
