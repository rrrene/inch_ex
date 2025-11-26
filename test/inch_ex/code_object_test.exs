defmodule InchEx.CodeObjectTest do
  use ExUnit.Case

  defp eval(input), do: [input] |> InchEx.CodeObject.eval() |> List.first()

  test "eval() works with function /1" do
    input = %{
      "doc" =>
        "Finds sources in a given `directory` using a list of `included` and `excluded`\npatterns. For `included`, patterns can be file paths, directory paths and globs.\nFor `excluded`, patterns can also be specified as regular expressions.\n\n    iex> Sources.find_in_dir(\"/home/rrrene/elixir\", [\"*.ex\"], [\"not_me.ex\"])\n\n    iex> Sources.find_in_dir(\"/home/rrrene/elixir\", [\"*.ex\"], [~r/messy/])\n",
      "location" => "lib/credo/sources.ex:107",
      "metadata" => %{source_annos: [{116, 7}]},
      "name" => "Credo.Sources.find_in_dir/3",
      "signature" => ["find_in_dir(working_dir, included, excluded)"],
      "type" => "function"
    }

    expected = %{
      "name" => "Credo.Sources.find_in_dir/3",
      "score" => 100,
      "grade" => "A",
      "doc" =>
        "Finds sources in a given `directory` using a list of `included` and `excluded`\npatterns. For `included`, patterns can be file paths, directory paths and globs.\nFor `excluded`, patterns can also be specified as regular expressions.\n\n    iex> Sources.find_in_dir(\"/home/rrrene/elixir\", [\"*.ex\"], [\"not_me.ex\"])\n\n    iex> Sources.find_in_dir(\"/home/rrrene/elixir\", [\"*.ex\"], [~r/messy/])\n",
      "location" => "lib/credo/sources.ex:107",
      "metadata" => %{},
      "priority" => 0,
      "roles" => [
        {"with_docstring", nil},
        {"with_multiple_code_examples", nil},
        {"without_children", nil},
        {"with_parameters", nil},
        {"without_function_parameter_mention", {:working_dir, 3}},
        {"with_function_parameter_mention", {:included, 3}},
        {"with_function_parameter_mention", {:excluded, 3}}
      ],
      "type" => "function"
    }

    assert eval(input) == expected
  end

  test "eval() works with function /2" do
    input = %{
      "doc" => nil,
      "location" => "lib/inch_ex/code_object/doc.ex:4",
      "metadata" => %{source_annos: [{4, 7}]},
      "name" => "InchEx.CodeObject.Docstring.present?/1",
      "signature" => ["present?(item)"],
      "type" => "function"
    }

    expected = %{
      "doc" => nil,
      "grade" => "U",
      "location" => "lib/inch_ex/code_object/doc.ex:4",
      "metadata" => %{},
      "name" => "InchEx.CodeObject.Docstring.present?/1",
      "priority" => -4,
      "roles" => [
        {"without_docstring", nil},
        {"without_code_example", nil},
        {"without_children", nil},
        {"with_parameters", nil},
        {"with_questioning_name", nil},
        {"without_function_parameter_mention", {:item, 1}}
      ],
      "score" => 0,
      "type" => "function"
    }

    assert eval(input) == expected
  end

  test "eval() works with module" do
    input = %{
      "doc" => "This module is used to find and read all source files for analysis.\n",
      "location" => "lib/credo/sources.ex:2",
      "metadata" => %{
        behaviours: [],
        source_annos: [{1, 1}],
        source_path: ~c"/home/rrrene/projects/credo/master/lib/credo/sources.ex"
      },
      "name" => "Credo.Sources",
      "type" => "module"
    }

    expected = %{
      "name" => "Credo.Sources",
      "score" => 100,
      "grade" => "A",
      "doc" => "This module is used to find and read all source files for analysis.\n",
      "location" => "lib/credo/sources.ex:2",
      "metadata" => %{},
      "priority" => 0,
      "roles" => [
        {"with_docstring", nil},
        {"without_code_example", nil},
        {"without_children", nil},
        {"without_parameters", nil}
      ],
      "type" => "module"
    }

    assert eval(input) == expected
  end
end
