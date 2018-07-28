defmodule InchEx.CodeObject.Doc do
  def present?(item), do: item |> get() |> to_string() != ""

  def get(%{"doc" => doc}) when is_binary(doc), do: doc
  def get(_), do: nil

  def mentions?(doc, name) when is_binary(doc) do
    doc =~ ~r/\`#{name}\`/ or doc =~ ~r/\+#{name}\+/ or doc =~ ~r"<tt>#{name}</tt>"
  end

  def mentions?(nil, _name), do: false

  def has_code_example?(%{} = item) do
    item
    |> get()
    |> to_string()
    |> has_code_example?()
  end

  def has_code_example?(item) when is_binary(item) do
    item =~ ~r/^    \w+/m
  end
end
