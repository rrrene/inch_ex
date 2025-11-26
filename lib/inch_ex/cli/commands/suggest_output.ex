defmodule InchEx.CLI.Commands.SuggestOutput do
  @distribution_grades ~w(U C B A)
  @suggest_grades ~w(B C U)

  alias InchEx.CLI
  alias InchEx.CodeObject.Grade
  alias InchEx.CodeObject.Priority
  alias InchEx.UI
  alias InchEx.UI.Sparkline

  @doc false
  def call(results, %{switches: %{format: "json"}}) do
    result_map = results_grouped_by_grade(results)
    distribution = distribution_for_grades(@distribution_grades, result_map) |> Enum.into(%{})
    data = %{"grade_distribution" => distribution}

    results
    |> InchEx.JSON.Mapping.from_results(data)
    |> InchEx.JSON.encode!()
    |> IO.puts()
  end

  def call(results, options) do
    shown_results =
      case options.switches do
        %{all: true} -> 1_000_000
        _ -> 10
      end

    term_width = CLI.term_columns()
    result_map = results_grouped_by_grade(results)

    Enum.each(
      @suggest_grades,
      &puts_results_for_grade(&1, result_map[&1], shown_results, term_width)
    )

    puts_suggested_files(results)
    puts_cry_for_help()
    puts_grade_distribution(result_map)
  end

  defp puts_results_for_grade(_grade, nil, _shown_results, _term_width), do: nil

  defp puts_results_for_grade(grade, results_for_grade, shown_results, term_width) do
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
      String.pad_trailing(description, term_width - 2)
    ])

    UI.puts([color, UI.edge()])

    results_for_grade
    |> Enum.take(shown_results)
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
    distribution = @distribution_grades |> distribution_for_grades(result_map) |> Keyword.values()

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

  defp results_grouped_by_grade(results) do
    results
    |> sort_results()
    |> Enum.group_by(& &1["grade"])
  end

  defp distribution_for_grades(grades, result_map) do
    Enum.map(grades, fn grade ->
      count =
        result_map[grade]
        |> List.wrap()
        |> Enum.count()

      {grade, count}
    end)
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
