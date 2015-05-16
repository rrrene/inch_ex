defmodule InchEx.Setup do
  def print(text, options \\ []) do
     IO.ANSI.Docs.print(text, options)
  end

  def print_heading(heading, options \\ []) do
     IO.ANSI.Docs.print_heading(heading, options)
  end

  def run(output) do
    InchEx.Setup.ReadmeBadge.run(output)
    InchEx.Setup.TravisAfterScript.run(output)
  end
end
