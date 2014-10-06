defmodule InchEx.Reporter.Remote do
  @build_api_end_point 'http://inch-ci.org/api/v1/builds'

  @doc """
    Runs inch remotely, if already invented.
  """
  def run(filename, _) do
    if valid? do
      data = File.read!(filename)
      case :httpc.request(:post, {inch_build_api_endpoint, [], 'application/json', data}, [], []) do
        {:ok, {_, _, body}} -> handle_output(body)
        {:error, {:failed_connect, _, _}} -> IO.puts "Connect failed."
        _ -> IO.puts "InchEx failed."
      end
    end
  end

  defp inch_build_api_endpoint do
    case System.get_env("INCH_BUILD_API") do
      nil -> @build_api_end_point
      url -> url
    end
  end

  defp handle_output(output) do
    # is this really the only way to binwrite to stdout?
    {:ok, pid} = StringIO.open("")
    IO.binwrite pid, output
    {_, contents} = StringIO.contents(pid)
    StringIO.close pid
    IO.write contents
  end

  # We do not want data from builds which only validate PRs
  defp valid? do
    System.get_env("TRAVIS_PULL_REQUEST") == "false"
  end
end
