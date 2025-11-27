defmodule InchEx.CodeObject.Score do
  @score_min 0
  @score_max 100
  @score_with_docstring_base 50
  @score_parameters_base 40
  @score_return_type 10
  @score_with_code_example 10
  @score_with_multiple_code_examples 25
  @score_with_metadata 20

  def min_score, do: @score_min
  def max_score, do: @score_max

  def run(roles, type) do
    roles
    |> Enum.map(&score(type, &1, roles))
    |> Enum.reject(&is_nil/1)
    |> Enum.reduce(0, &(&1 + &2))
    |> max(min_score())
    |> min(max_score())
  end

  @doc "Returns a score for the given `type` and `role`."
  def score(type, role, roles)

  def score("module", {"with_docstring", _}, _), do: 100
  def score("module", {"with_code_example", _}, _), do: 10
  def score("module", {"with_multiple_code_examples", _}, _), do: 25
  def score("module", {"with_metadata", _}, _), do: 20

  #########################
  ## FUNCTION
  #
  # docstring           0.5
  # parameters          0.4
  # return_type         0.1
  # return_description  0.3

  # if object.questioning_name?
  #   parameters          parameters + return_type
  #   return_type         0.0
  # end

  # if !object.has_parameters?
  #   return_description  docstring + parameters
  #   docstring           docstring + parameters
  #   parameters          0.0
  # end

  # # optional:
  # code_example_single 0.1
  # code_example_multi  0.25
  # unconsidered_tag    0.2

  def score("function", {"with_docstring", _}, roles) do
    add_parameter_score? = has_role?(roles, "without_parameters")

    if add_parameter_score? do
      @score_with_docstring_base + @score_parameters_base
    else
      @score_with_docstring_base
    end
  end

  def score("function", {"with_code_example", _}, _), do: @score_with_code_example

  def score("function", {"with_multiple_code_examples", _}, _),
    do: @score_with_multiple_code_examples

  def score("function", {"with_metadata", _}, _), do: @score_with_metadata

  def score("function", {"with_function_parameter_mention", {_name, count}}, roles) do
    add_return_score? = has_role?(roles, "with_questioning_name")

    base_score =
      if add_return_score? do
        @score_parameters_base + @score_return_type
      else
        @score_parameters_base
      end

    div(base_score, count)
  end

  def score("macro", role, roles), do: score("function", role, roles)

  def score(_, _, _), do: nil

  defp has_role?(roles, role_name) do
    Enum.any?(roles, fn
      {^role_name, _} -> true
      _ -> false
    end)
  end

  def potential_score(type, {role, value}, roles) do
    if String.match?(role, ~r/(without)/) do
      with_role = String.replace(role, "without", "with")

      score(type, {with_role, value}, roles)
    end
  end
end
