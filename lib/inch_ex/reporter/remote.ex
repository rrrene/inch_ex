defmodule InchEx.Reporter.Remote do
  @build_api_end_point 'https://inch-ci.org/api/v1/builds'

  @doc """
    Runs inch remotely, if already invented.

    Returns a tuple `{:ok, _}` if successful, `{:error, _}` otherwise.
  """
  def run(filename, _) do
    if valid?() do
      data = File.read!(filename)
      case :httpc.request(:post, {inch_build_api_endpoint(), [], 'application/json', data}, [], []) do
        {:ok, {_, _, body}} -> InchEx.Reporter.handle_success(body)
        {:error, {:failed_connect, _, _}} -> InchEx.Reporter.handle_error "InchEx failed to connect."
        _ -> InchEx.Reporter.handle_error "InchEx failed."
      end
    else
      InchEx.Reporter.handle_error "InchEx skipped (#{reason_for_invalidity()})."
    end
  end

  defp inch_build_api_endpoint do
    case System.get_env("INCH_BUILD_API") do
      nil -> @build_api_end_point
      url -> url |> String.to_charlist
    end
  end

  # We do not want data from builds which only validate PRs
  defp valid? do
    InchEx.Env.env
    |> valid?()
  end

  defp reason_for_invalidity do
    InchEx.Env.env
    |> reason_for_invalidity()
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
  defp valid?(_), do: true
end
