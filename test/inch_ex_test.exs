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

  @tag :test_fixtures
  test "inch_test does work with inch_ex" do
    "inch_test"
    |> load_json()
    |> assert_result("InchTest.some_delegated_doc/1")
    |> assert_result("InchTest.some_macro/1")
    |> assert_result("InchTest.t/0", %{"grade" => "A"})
    |> assert_result("InchTest.SomeGenServer")
    |> refute_result("InchTest.SomeGenServer.init/1")
  end

  defp load_json(fixture_name) do
    with {:ok, content} <- File.read("test_fixtures/#{fixture_name}.json"),
         {:ok, json} <- Jason.decode(content) do
      json
    else
      _ ->
        assert false, "Could not load fixture"
    end
  end

  defp assert_result(%{"results" => list} = json, name) do
    assert Enum.any?(list, &(&1["name"] == name))

    json
  end

  defp assert_result(%{"results" => list} = json, name, expected) when is_map(expected) do
    assert Enum.any?(list, fn item ->
             item["name"] == name && Map.intersect(item, expected) == expected
           end)

    json
  end

  defp refute_result(%{"results" => list} = json, name) do
    refute Enum.any?(list, &(&1["name"] == name))

    json
  end
end
