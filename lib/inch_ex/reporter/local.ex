defmodule InchEx.Reporter.Local do
  @cli_api_end_point 'https://inch-ci.org/api/v1/cli'

  @doc """
    Runs inch locally, if installed. If you want to force usage of a particular
    inch installation, set INCH_PATH environment variable:

      export INCH_PATH=/home/rrrene/projects/inch

    Otherwise, InchEx will take whatever `inch` command it finds. If it does
    not find any, it sends the data to the open API at inch-ci.org (or the
    endpoint defined in the INCH_CLI_API environment variable) to perform
    the analysis and reports the findings back.

    Returns a tuple `{:ok, _}` if successful, `{:error, _}` otherwise.
  """
  def run(filename, args \\ []) do
    if local_inch?() do
      local_inch(args ++ ["--language=elixir", "--read-from-dump=#{filename}"])
    else
      data = File.read!(filename)
      case :httpc.request(:post, {inch_cli_api_endpoint(), [], 'application/json', data}, [], []) do
        {:ok, {_, _, body}} -> InchEx.Reporter.handle_success(body)
        {:error, {:failed_connect, _, _}} -> InchEx.Reporter.handle_error "Connect failed."
        _ -> InchEx.Reporter.handle_error "InchEx failed."
      end
    end
  end

  defp inch_cli_api_endpoint do
    case System.get_env("INCH_CLI_API") do
      nil -> @cli_api_end_point
      url -> to_charlist url
    end
  end

  defp inch_cmd do
    case System.get_env("INCH_PATH") do
      nil -> System.find_executable("inch")
      dir -> Path.join([dir, "bin", "inch"])
    end
  end

  defp local_inch? do
    !is_nil(inch_cmd())
  end

  defp local_inch(args) do
    case System.cmd(inch_cmd(), args) do
      {output, 0} -> InchEx.Reporter.handle_success(output)
      {output, _} -> InchEx.Reporter.handle_error(output)
    end
  end
end
