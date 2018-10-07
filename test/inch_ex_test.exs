defmodule InchExTest do
  use ExUnit.Case

  # test "the truth" do
  #   tuples = {:test, nil, {:other, nil, {:third, 32}}, {:other, nil, [:fourth, 42]}}
  #   lists = [:test, nil, [:other, nil, [:third, 32]], [:other, nil, [:fourth, 42]]]
  #   assert InchEx.Helper.map_tuple_to_list(tuples) == lists
  # end

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
