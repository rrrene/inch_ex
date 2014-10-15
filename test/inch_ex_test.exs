defmodule InchExTest do
  use ExUnit.Case

  test "the truth" do
    tuples = {:test, nil, {:other, nil, {:third, 32}}, {:other, nil, [:fourth, 42]}}
    lists = [:test, nil, [:other, nil, [:third, 32]], [:other, nil, [:fourth, 42]]]
    assert InchEx.Helper.map_tuple_to_list(tuples) == lists
  end
end
