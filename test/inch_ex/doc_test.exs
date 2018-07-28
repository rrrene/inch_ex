defmodule InchEx.CodeObjectDocTest do
  @example1 %{
    "type" => "def",
    "source" => "lib/credo/backports/enum.ex:25",
    "signature" => [
      ["list", [], nil],
      ["count", [], nil],
      ["step", [], nil]
    ],
    "object_type" => "FunctionObject",
    "name" => "chunk_every",
    "module_id" => "Credo.Backports.Enum",
    "id" => "chunk_every/3",
    "doc" =>
      "Splits the enumerable in two lists according to the given function fun.\n\n    iex> Credo.Backports.Enum.chunk_every([1, 2, 3, 4, 5, 6], 2, 1)\n    [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6]]\n\n",
    "arity" => 3
  }

  use ExUnit.Case

  alias InchEx.CodeObject.Doc

  test "get/1 works as expected /1" do
    input = @example1

    expected =
      "Splits the enumerable in two lists according to the given function fun.\n\n    iex> Credo.Backports.Enum.chunk_every([1, 2, 3, 4, 5, 6], 2, 1)\n    [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6]]\n\n"

    result = Doc.get(input)

    assert expected == result
  end

  test "has_code_example?/1 works as expected /1" do
    input = @example1

    assert Doc.has_code_example?(input)
  end
end
