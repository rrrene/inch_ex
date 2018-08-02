defmodule InchEx.CodeObject.Priority do
  def run(roles, type) do
    roles
    |> Enum.map(&priority(type, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def priority("module", {"in_root", _}), do: +3
  def priority("module", {"with_many_children", _}), do: +2

  def priority("module", {"without_functions", _}), do: -2
  def priority("module", {"only_modules_as_children", _}), do: -2

  def priority("function", {"with_many_parameters", _}), do: +2
  def priority("function", {"with_bang_name", _}), do: +3
  def priority("function", {"with_questioning_name", _}), do: -4

  def priority(_, _), do: nil

  def potential_priority(type, {role, value}) do
    if String.match?(role, ~r/(without)/) do
      with_role = String.replace(role, "without", "with")

      priority(type, {with_role, value})
    end
  end

  @doc "Returns an arrow character visually representing the priority."
  def arrow(p) when p in 4..9999, do: "\u2191"
  def arrow(p) when p in 2..3, do: "\u2197"
  def arrow(p) when p in 0..1, do: "\u2192"
  def arrow(p) when p in -2..-1, do: "\u2198"
  def arrow(p) when p in -9999..-3, do: "\u2193"
  def arrow(_), do: "x"
end
