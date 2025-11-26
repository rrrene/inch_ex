defmodule InchExTest do
  use ExUnit.Case

  @tag :skip
  test "json read" do
    input =
      "inch_test_input.json"
      |> File.read!()
      |> Jason.decode!()
      |> Map.get("objects")

    expected =
      "inch_test_result.json"
      |> File.read!()
      |> Jason.decode!()
      |> Map.get("objects")

    results = InchEx.CodeObject.eval(input)

    assert List.first(expected) == List.first(results)
    assert expected == results
  end
end
