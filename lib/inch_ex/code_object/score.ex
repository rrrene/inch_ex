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

  #########################
  ## MODULE
  #
  # docstring           1.0

  # # optional:
  # code_example_single 0.1
  # code_example_multi  0.2
  # unconsidered_tag    0.2

  def score("module", "with_doc"), do: 100
  def score("module", "with_code_example"), do: 10
  def score("module", "with_code_example_multi"), do: 20

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

  def score("function", "with_doc"), do: 50
  def score("function", "with_code_example"), do: 10
  def score("function", "with_code_example_multi"), do: 25
  def score("function", "with_metadata"), do: 20

  def score(_, _), do: nil

  def potential_score(type, role) do
    if String.match?(role, ~r/(without)/) do
      with_role = String.replace(role, "without", "with")

      score(type, with_role)
    end
  end
end
