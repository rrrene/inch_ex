defmodule InchEx.CLI.Commands.ExplainOutput do
  alias InchEx.CLI
  alias InchEx.UI
  alias InchEx.CodeObject.Priority
  alias InchEx.CodeObject.Score

  @column_width1 50
  @column_width2 10
  @column_width3 5

  @doc false
  def call(result)

  def call(results) when is_list(results) do
    Enum.each(results, &call/1)
  end

  def call(result) do
    term_width = CLI.term_columns()

    %{
      "location" => location,
      "name" => name,
      "priority" => priority,
      "roles" => roles,
      "score" => score,
      "type" => type
    } = result

    color = :orange
    bg_color = nil
    bg_color = if bg_color, do: :"#{bg_color}_background", else: :"#{color}_background"

    UI.puts()

    UI.puts([
      bg_color,
      color,
      "#",
      :reset,
      bg_color,
      " ",
      :black,
      String.pad_trailing(name, term_width - 2)
    ])

    UI.puts([color, UI.edge(), :reset, " ", :faint, location])

    UI.puts([color, :faint, UI.edge(), " ", :faint, String.pad_trailing("", term_width - 2, "-")])

    Enum.each(roles, fn role_tuple ->
      score = Score.score(type, role_tuple, roles) || 0
      priority = Priority.priority(type, role_tuple) || 0
      potential_score = Score.potential_score(type, role_tuple, roles)
      potential_priority = Priority.potential_priority(type, role_tuple)

      role_title = InchEx.CodeObject.Roles.title(role_tuple)

      role_text =
        if potential_score do
          [:faint, String.pad_trailing(role_title, @column_width1)]
        else
          String.pad_trailing(role_title, @column_width1)
        end

      role_score =
        if potential_score do
          [:faint, String.pad_leading("(#{potential_score})", @column_width2)]
        else
          String.pad_leading("#{score} ", @column_width2)
        end

      role_priority =
        if potential_priority do
          [:faint, String.pad_leading(to_string(potential_priority), @column_width3)]
        else
          String.pad_leading(to_string(priority), @column_width3)
        end

      if score > 0 || (!is_nil(potential_score) && potential_score > 0) do
        UI.puts([
          color,
          :faint,
          UI.edge(),
          :reset,
          " ",
          role_text,
          role_score,
          role_priority
        ])
      end
    end)

    UI.puts([color, :faint, UI.edge(), " ", :faint, String.pad_trailing("", term_width - 2, "-")])

    min_score = InchEx.CodeObject.Score.min_score()
    max_score = InchEx.CodeObject.Score.max_score()
    text = "Score (min: #{min_score}, max: #{max_score})"

    UI.puts([
      color,
      :faint,
      UI.edge(),
      :reset,
      " ",
      String.pad_trailing(text, @column_width1),
      String.pad_leading("#{score} ", @column_width2),
      String.pad_leading(to_string(priority), @column_width3)
    ])

    UI.puts([color, :faint, UI.edge()])
  end
end
