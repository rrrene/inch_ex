defmodule InchEx.CLI.Env do
  @env_var_skip_report "INCH_SKIP_REPORT"

  def env do
    cond do
      circleci?() -> :circleci
      travis?() -> :travis
      generic_ci?() -> :generic_ci
      true -> :unknown
    end
  end

  # We do not want data from builds which only validate PRs
  def valid? do
    if System.get_env(@env_var_skip_report) == "true" do
      false
    else
      env() |> valid?()
    end
  end

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

  defp valid?(_), do: false


  @doc "Returns true if not run on any known CI, but seems to be on CI."
  def generic_ci? do
    !circleci?() && !travis?() && System.get_env("CI") == "true"
  end

  @doc "Returns true if run on CircleCI."
  def circleci? do
    System.get_env("CIRCLECI") == "true"
  end

  @doc "Returns true if run on Travis."
  def travis? do
    System.get_env("TRAVIS") == "true"
  end

  def reason_for_invalidity do
    if System.get_env(@env_var_skip_report) == "true" do
      "#{@env_var_skip_report} set to true"
    else
      env() |> reason_for_invalidity()
    end
  end

  defp reason_for_invalidity(:circleci), do: "pull request on Circle CI"
  defp reason_for_invalidity(:travis), do: "pull request on Travis CI"
  defp reason_for_invalidity(_), do: "could not detect CI service"
end
