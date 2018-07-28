defmodule InchEx.CLI.Commands.SuggestOutput do
  @distribution_grades ~w(U C B A)
  @suggest_grades ~w(B C U)

  alias InchEx.CLI
  alias InchEx.CodeObject.Grade
  alias InchEx.CodeObject.Priority
  alias InchEx.UI
  alias InchEx.UI.Sparkline

  @doc false
  def call(results) do
    term_width = CLI.term_columns()

    result_map =
      results
      |> sort_results()
      |> Enum.group_by(& &1["grade"])

    Enum.each(@suggest_grades, &puts_results_for_grade(&1, result_map[&1], term_width))

    puts_suggested_files(results)
    puts_cry_for_help()
    puts_grade_distribution(result_map)
  end

  defp puts_results_for_grade(_grade, nil, _term_width), do: nil

  defp puts_results_for_grade(grade, results_for_grade, term_width) do
    color = Grade.color(grade)
    bg_color = Grade.bg_color(grade)
    bg_color = if bg_color, do: :"#{bg_color}_background", else: :"#{color}_background"
    description = Grade.description(grade)

    UI.puts()

    UI.puts([
      bg_color,
      color,
      "#",
      :reset,
      bg_color,
      " ",
      :black,
      String.pad_trailing(description, term_width)
    ])

    UI.puts([color, UI.edge()])

    results_for_grade
    |> Enum.take(10)
    |> Enum.each(fn item ->
      arrow = Priority.arrow(item["priority"])

      UI.puts([
        color,
        UI.edge(),
        " [",
        grade,
        "] ",
        :faint,
        arrow,
        " ",
        :reset,
        color,
        item["name"],
        :reset,
        :faint,
        " (",
        item["location"],
        ")"
      ])
    end)
  end

  defp puts_suggested_files(results) do
    files = files_to_suggest(results)

    UI.puts("\nYou might want to look at these files:\n")

    Enum.each(files, fn file ->
      UI.puts([:faint, UI.edge(), "  ", file])
    end)
  end

  defp puts_cry_for_help do
    UI.puts()
    UI.puts([:faint, "Please report incorrect results: https://github.com/rrrene/inch_ex/issues"])
  end

  defp puts_grade_distribution(result_map) do
    distribution =
      Enum.map(@distribution_grades, &(result_map[&1] |> List.wrap() |> Enum.count()))

    colors = Enum.map(@distribution_grades, &Grade.color/1)

    sparkline =
      Sparkline.run(distribution, fn value, index, _ ->
        [Enum.at(colors, index), value, " "]
      end)

    UI.puts()
    UI.puts(["Grade distribution (undocumented, C, B, A): ", sparkline])
    UI.puts()
    UI.puts([:faint, "Only considering priority objects: ↑ ↗ →  (use `--help` for options)."])
  end

  defp sort_results(results) do
    results
    |> Enum.group_by(& &1["priority"])
    |> Enum.flat_map(fn {_priority, list} ->
      Enum.sort_by(list, &String.length(&1["name"]))
    end)
    |> Enum.sort_by(& &1["priority"])
  end

  defp files_to_suggest(results) do
    results
    |> Enum.group_by(fn item ->
      item["location"]
      |> String.split(":")
      |> List.first()
    end)
    |> Enum.map(fn {key, list} -> {Enum.count(list), key} end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(5)
    |> Enum.map(fn {_, filename} -> filename end)
  end
end
