defmodule InchEx.Setup.TravisAfterScript do
  @travis_filename ".travis.yml"
  @sample_project "https://github.com/inch-ci/Hello-World-Elixir"

  def run? do
    File.exists?(@travis_filename)
  end

  def run(_) do
    if run?() do
      textify() |> InchEx.Setup.print
    end
  end

  defp textify() do
    """
    ## Run InchEx automatically via Travis

    To run InchEx every time your tests run, configure InchEx as a dependency only loaded in the `docs` environment. Update the `:inch_ex` dependency with the `:only` option:

        defp deps do
          [
            ...
            {:inch_ex, only: :docs}
          ]
        end

    Then, add the following `after_script` to your #{@travis_filename}:

        after_script:
          - mix deps.get --only docs
          - MIX_ENV=docs mix inch.report

    Example on GitHub: #{@sample_project}
    """
  end
end
