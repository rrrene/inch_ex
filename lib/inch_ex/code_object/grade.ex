defmodule InchEx.CodeObject.Grade do
  @doc "Returns the grade for the given `score`."
  def run(score) when score in 80..9999, do: "A"
  def run(score) when score in 50..80, do: "B"
  def run(score) when score in 1..50, do: "C"
  def run(score) when score in 0..0, do: "U"

  @doc "Returns the description for the given `grade`."
  def description("A"), do: "Seems really good"
  def description("B"), do: "Proper documentation present"
  def description("C"), do: "Needs work"
  def description("U"), do: "Undocumented"

  @doc "Returns the color for the given `grade`."
  def color("A"), do: :green
  def color("B"), do: :yellow
  def color("C"), do: :red
  def color("U"), do: :color141

  @doc "Returns the background color for the given `grade`."
  def bg_color("A"), do: nil
  def bg_color("B"), do: nil
  def bg_color("C"), do: nil
  def bg_color("U"), do: :color105
end
