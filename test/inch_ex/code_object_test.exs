defmodule InchEx.CodeObjectTest do
  use ExUnit.Case

  test "eval() works as expected /1" do
    input = %{
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

    expected = %{
      "fullname" => "Credo.Backports.Enum.chunk_every/3",
      "score" => 60,
      "roles" => [
        "object_withdoc",
        "object_withcodeexample",
        "functionparameter_withoutmention",
        "functionparameter_withoutmention",
        "functionparameter_withoutmention"
      ],
      "grade" => "B"
    }

    result = [input] |> InchEx.CodeObject.eval() |> List.first()

    assert expected == result
  end

  test "eval() works as expected /2" do
    input = %{
      "type" => nil,
      "source" => "lib/credo/cli.ex:2",
      "object_type" => "ModuleObject",
      "moduledoc" =>
        "`Credo.CLI` is the entrypoint for both the Mix task and the escript.\n\nIt takes the parameters passed from the command line and translates them into\na Command module (see the `Credo.CLI.Command` namespace), the work directory\nwhere the Command should run and a `Credo.Execution` struct.\n",
      "module" => "Elixir.Credo.CLI",
      "id" => "Credo.CLI"
    }

    expected = %{
      "fullname" => "Credo.CLI",
      "score" => 100,
      "roles" => [
        "object_withdoc",
        "object_withoutcodeexample"
      ],
      "grade" => "A"
    }

    result = [input] |> InchEx.CodeObject.eval() |> List.first()

    assert expected == result
  end
end
