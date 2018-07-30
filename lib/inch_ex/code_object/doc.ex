defmodule InchEx.CodeObject.Docstring do
  @code_example_regex ~r/(^    \S+.+\n){1,}/m

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

  def has_code_example?(docstring) when is_binary(docstring) do
    docstring =~ @code_example_regex
  end

  def has_multiple_code_examples?(%{} = item) do
    item
    |> get()
    |> to_string()
    |> has_multiple_code_examples?()
  end

  def has_multiple_code_examples?(docstring) when is_binary(docstring) do
    examples = Regex.scan(@code_example_regex, docstring)

    Enum.count(examples) > 1
  end
end
