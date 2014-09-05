defmodule InchEx.Reporter.Local do
  @cli_api_end_point 'http://inch-ci.org/api/v1/cli'

  @doc """
    Runs inch locally, if installed. If you want to force usage of a particular
    inch installation, set INCH_PATH environment variable:

      export INCH_PATH=/home/rrrene/projects/inch

    Otherwise, InchEx will take whatever `inch` command it finds. If it does
    not find any, it sends the data to the open API at inch-ci.org to perform
    the analysis and reports the findings back.
  """
  def run(filename, args \\ []) do
    if local_inch? do
      local_inch(args ++ ["--language=elixir", "--read-from-dump=#{filename}"])
    else
      data = File.read!(filename)
      case :httpc.request(:post, {inch_cli_api_endpoint, [], 'application/json', data}, [], []) do
        {:ok, {_, _, body}} -> handle_output(body)
        {:error, {:failed_connect, _, _}} -> IO.puts "Connect failed."
        asdf -> IO.puts "Connect failed."
      end
    end
  end

  defp inch_cli_api_endpoint do
    case System.get_env("INCH_CLI_API") do
      nil -> @cli_api_end_point
      url -> url
    end
  end

  defp inch_cmd do
    case System.get_env("INCH_PATH") do
      nil -> System.find_executable("inch")
      dir -> Path.join([dir, "bin", "inch"])
    end
  end

  defp local_inch? do
    !is_nil(inch_cmd)
  end

  defp local_inch(args \\ []) do
    case System.cmd(inch_cmd, args) do
      {output, 0} -> handle_output(output)
      {output, _} -> handle_error(output)
    end
  end

  defp local_inch_version do
    case System.cmd(inch_cmd, ["--version"]) do
      {output, 0} -> local_inch_version(output)
      {output, _} -> handle_error(output)
    end
  end

  defp local_inch_version("inch " <> major = name) do
    String.strip(major)
  end

  defp handle_output(output) do
    # is this really the only way to binwrite to stdout?
    {:ok, pid} = StringIO.open("")
    IO.binwrite pid, output
    {_, contents} = StringIO.contents(pid)
    StringIO.close pid
    IO.write contents
  end

  defp handle_error(output) do
    IO.puts output
    IO.puts "Inch exited with non-zero result"
  end
end
