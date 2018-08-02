defmodule InchEx.CodeObject.Score do
  @min_score 0
  @max_score 100

  def min_score, do: @min_score
  def max_score, do: @max_score

  def run(roles, type) do
    roles
    |> Enum.map(&score(type, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.reduce(0, &(&1 + &2))
    |> max(min_score())
    |> min(max_score())
  end

  @doc "Returns a score for the given `type` and `role`."
  def score(type, role)

  def score("module", {"with_docstring", _}), do: 100
  def score("module", {"with_code_example", _}), do: 10
  def score("module", {"with_multiple_code_examples", _}), do: 25
  def score("module", {"with_metadata", _}), do: 20

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

  # if !object.has_parameters? || object.setter?
  #   return_description  docstring + parameters
  #   docstring           docstring + parameters
  #   parameters          0.0
  # end

  # # optional:
  # code_example_single 0.1
  # code_example_multi  0.25
  # unconsidered_tag    0.2

  def score("function", {"with_docstring", _}), do: 50
  def score("function", {"with_code_example", _}), do: 10
  def score("function", {"with_multiple_code_examples", _}), do: 25
  def score("function", {"with_metadata", _}), do: 20
  def score("function", {"with_function_parameter_mention", {_name, count}}), do: div(40, count)

  def score(_, _), do: nil

  def potential_score(type, {role, value}) do
    if String.match?(role, ~r/(without)/) do
      with_role = String.replace(role, "without", "with")

      score(type, {with_role, value})
    end
  end
end
