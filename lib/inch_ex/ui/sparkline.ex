defmodule InchEx.UI.Sparkline do
  @ticks ~w(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
  @steps Enum.count(@ticks) - 1
  @default_separator ""

  def run(original_numbers, format_callback \\ nil) do
    numbers = normalize_numbers(original_numbers)
    one_step = step_height(numbers)

    numbers
    |> Enum.with_index()
    |> Enum.map(fn {n, index} ->
      tick = trunc(n / one_step)
      value = Enum.at(@ticks, tick)

      if format_callback do
        format_callback.(value, index, n)
      else
        value
      end
    end)
  end

  def normalize_numbers(numbers) do
    min = numbers |> Enum.sort() |> List.first()

    Enum.map(numbers, &(&1 - min))
  end

  def step_height(numbers) do
    sorted = numbers |> Enum.sort()
    min = List.first(sorted)
    max = List.last(sorted)
    actual_height = max - min
    step = actual_height / @steps

    if step == 0 do
      1
    else
      step
    end
  end
end
