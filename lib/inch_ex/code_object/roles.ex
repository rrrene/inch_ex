defmodule InchEx.CodeObject.Roles do
  @ignored_metadata_keys [:defaults]

  @many_parameters_threshold 5

  @role_with_many_children "with_many_children"
  @role_with_children "with_children"
  @role_in_root "in_root"
  @role_with_doc "with_docstring"
  @role_without_doc "without_docstring"
  @role_with_code_example "with_code_example"
  @role_with_multiple_code_examples "with_multiple_code_examples"
  @role_without_code_example "without_code_example"
  @role_with_many_parameters "with_many_parameters"
  @role_with_bang_name "with_bang_name"
  @role_with_metadata "with_metadata"
  @role_with_questioning_name "with_questioning_name"
  @role_function_parameter_with_mention "with_function_parameter_mention"
  @role_function_parameter_without_mention "without_function_parameter_mention"

  alias InchEx.CodeObject.Docstring

  def run(item) do
    [
      in_root(item),
      with_without_doc(item),
      with_without_code_example(item),
      children(item),
      parameters(item),
      name(item),
      metadata(item),
      functionparameter_with_withoutmention(item)
    ]
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  def in_root(%{"name" => name}) do
    depth =
      name
      |> String.split(".")
      |> Enum.count()

    if depth == 1, do: to_role(@role_in_root)
  end

  def children(%{"children" => x}) when x > 20, do: to_role(@role_with_many_children)
  def children(%{"children" => x}) when x > 1, do: to_role(@role_with_children)
  def children(_), do: nil

  def with_without_doc(item) do
    if Docstring.present?(item) do
      to_role(@role_with_doc)
    else
      to_role(@role_without_doc)
    end
  end

  def with_without_code_example(item) do
    cond do
      Docstring.has_multiple_code_examples?(item) -> to_role(@role_with_multiple_code_examples)
      Docstring.has_code_example?(item) -> to_role(@role_with_code_example)
      true -> to_role(@role_without_code_example)
    end
  end

  def parameters(item) do
    names = item |> fun_params() |> List.wrap()

    if Enum.count(names) > @many_parameters_threshold do
      to_role(@role_with_many_parameters)
    end
  end

  def name(%{"name" => name}) do
    case Regex.scan(~r/([\!\?])\/\d$/, name) do
      [[_, "!"]] -> to_role(@role_with_bang_name)
      [[_, "?"]] -> to_role(@role_with_questioning_name)
      [] -> nil
    end
  end

  defp metadata(%{"metadata" => metadata}) do
    metadata
    |> Map.drop(@ignored_metadata_keys)
    |> Enum.map(fn {key, _value} ->
      to_role(@role_with_metadata, key)
    end)
  end

  defp functionparameter_with_withoutmention(%{"signature" => _} = item) do
    names = fun_params(item)
    count = Enum.count(names)
    doc = Docstring.get(item)

    Enum.map(names, fn name ->
      if Docstring.mentions?(doc, name) do
        to_role(@role_function_parameter_with_mention, {name, count})
      else
        to_role(@role_function_parameter_without_mention, {name, count})
      end
    end)
  end

  defp functionparameter_with_withoutmention(_), do: nil

  defp fun_params(%{"signature" => list}) do
    list =
      Enum.map(list, fn string ->
        {_fun_name, _meta, parameters} = Code.string_to_quoted!(string)

        parameters
      end)

    {_, list} = Macro.prewalk(list, [], &traverse_fun_params/2)

    Enum.reverse(list)
  end

  defp fun_params(_), do: nil

  defp traverse_fun_params({name, _meta, nil}, acc) when is_atom(name) do
    {nil, [name] ++ acc}
  end

  defp traverse_fun_params(item, acc) do
    {item, acc}
  end

  defp to_role(role_name), do: {role_name, nil}
  defp to_role(role_name, meta), do: {role_name, meta}

  #

  @doc "Returns a human-readable title for the given `role`."
  def title(role)

  def title({"with_many_children", _}), do: "Has many children"
  def title({"with_children", _}), do: "Has children"
  def title({"in_root", _}), do: "At the top level"
  def title({"with_docstring", _}), do: "Has documentation"
  def title({"without_docstring", _}), do: "Misses documentation"
  def title({"with_code_example", _}), do: "Has a code example"
  def title({"with_multiple_code_examples", _}), do: "Has multiple code examples"
  def title({"without_code_example", _}), do: "Misses a code example"
  def title({"with_many_parameters", _}), do: "Has many parameters"
  def title({"with_bang_name", _}), do: "Has a bang name (ending in `!`)"
  def title({"with_questioning_name", _}), do: "Has a questioning name (ending in `?`)"

  def title({"with_function_parameter_mention", {name, _count}}),
    do: "Mentions function parameter `#{name}`"

  def title({"without_function_parameter_mention", {name, _count}}),
    do: "Misses mentioning function parameter `#{name}`"

  def title({role, _}), do: "Missing title for `#{role}`."
end
