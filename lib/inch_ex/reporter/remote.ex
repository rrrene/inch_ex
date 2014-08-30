defmodule InchEx.Reporter.Remote do
  @api_end_point 'http://localhost:3000/api/cli'

  @doc """
    Runs inch remotely, if already invented.
  """
  def run(filename, config \\ Mix.Project.config) do
    if valid? do
      data = File.read!(filename)
      :httpc.request(:post, {@api_end_point, [], 'application/json', data}, [], [])
    end
  end

  defp valid? do
    System.get_env("TRAVIS_PULL_REQUEST") == "false"
  end
end
