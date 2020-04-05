defmodule InchEx.CLI.Commands.ReportCommand do
  @env_var_skip_report "INCH_SKIP_REPORT"
  @build_api_end_point "https://inch-ci.org/api/v2/builds"

  alias InchEx.CLI.Options
  alias InchEx.CodeObject
  alias InchEx.Docs

  alias InchEx.CLI.Commands.ReportOutput

  @doc false
  def call(argv) do
    if valid?() do
      options = Options.parse(argv)

      options
      |> locate_docs()
      |> fetch_and_evaluate_docs()
      |> send_results(inch_build_api_endpoint())
    else
      ReportOutput.handle_error("InchEx skipped (reason: #{reason_for_invalidity()}).")
    end
  end

  defp locate_docs(options) do
    Docs.beam_files(options.path)
  end

  defp fetch_and_evaluate_docs(beam_files) when is_list(beam_files) do
    beam_files
    |> Enum.map(&Task.async(fn -> fetch_and_evaluate_docs(&1) end))
    |> Enum.flat_map(&Task.await(&1, :infinity))
  end

  defp fetch_and_evaluate_docs(beam_file) when is_binary(beam_file) do
    beam_file
    |> Docs.get_docs()
    |> CodeObject.eval()
  end

  defp inch_build_api_endpoint do
    url =
      case System.get_env("INCH_BUILD_API") do
        nil -> @build_api_end_point
        url -> url
      end

    String.to_charlist(url)
  end

  defp send_results(results, url) do
    ReportOutput.call(results, url)
  end

  # We do not want data from builds which only validate PRs
  defp valid? do
    if System.get_env(@env_var_skip_report) == "true" do
      false
    else
      env() |> valid?()
    end
  end

  defp reason_for_invalidity do
    if System.get_env(@env_var_skip_report) == "true" do
      "#{@env_var_skip_report} set to true"
    else
      env() |> reason_for_invalidity()
    end
  end

  defp reason_for_invalidity(:circleci), do: "pull request on Circle CI"
  defp reason_for_invalidity(:travis), do: "pull request on Travis CI"
  defp reason_for_invalidity(_), do: "could not detect CI service"

  # We do not want data from builds which only validate PRs
  defp valid?(:travis) do
    System.get_env("TRAVIS_PULL_REQUEST") == "false"
  end

  # We do not want data from builds which only validate PRs
  defp valid?(:circleci) do
    pr = System.get_env("CI_PULL_REQUEST")

    is_nil(pr) || pr == ""
  end

  defp valid?(:generic_ci), do: true

  defp valid?(:github_actions), do: true

  defp valid?(_), do: false

  defp env do
    cond do
      circleci?() -> :circleci
      travis?() -> :travis
      github_actions?() -> :github_actions
      generic_ci?() -> :generic_ci
      true -> :unknown
    end
  end

  # Returns true if not run on any known CI, but seems to be on CI.
  defp generic_ci? do
    !github_actions?() && !circleci?() && !travis?() && System.get_env("CI") == "true"
  end

  # Returns true if run on GitHub Actions.
  defp github_actions? do
    System.get_env("GITHUB_ACTIONS") == "true"
  end

  # Returns true if run on CircleCI.
  defp circleci? do
    System.get_env("CIRCLECI") == "true"
  end

  # Returns true if run on Travis.
  defp travis? do
    System.get_env("TRAVIS") == "true"
  end
end
