defmodule InchEx.Setup.ReadmeBadge do
  @readme_filename "README.md"

  def run? do
    File.exists?(@readme_filename)
  end

  def run(output) do
    if run?() do
      IO.puts ""
      extract_url(output) |> get_badge_url |> textify |> InchEx.Setup.print
    end
  end

  defp textify(badge_url) do
    """
    ## Documentation as first-class citizen

    You can now add this badge to your #{@readme_filename}:

        #{badge_url}
    """
  end

  defp extract_url(text) do
    [_, url] = Regex.run(~r/URL:\ (.+)$/, text)
    url
  end

  defp get_badge_url(project_url) do
    "[![Inline docs](#{project_url}.svg)](#{project_url})"
  end
end
