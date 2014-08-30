defmodule InchEx.Reporter.Local do
  @doc """
    Runs inch locally, if installed. If you want to force usage of a particular
    inch installation, set INCH_PATH environment variable to it.

      export INCH_PATH=/home/rrrene/projects/inch
  """
  def run(filename, args \\ []) do
    if local_inch? do
      local_inch(args ++ ["--language=elixir", "--read-from-dump=#{filename}"])
    else
      data = File.read!(filename)
      {:ok, {_, _, body}} = :httpc.request(:post, {'http://localhost:3000/api/cli', [], 'application/json', data}, [], [])
      IO.puts body
    end
  end

  defp local_inch? do
    !nil?(inch_cmd)
  end

  defp inch_cmd do
    case System.get_env("INCH_PATH") do
      nil -> System.find_executable("inch")
      dir -> Path.join([dir, "bin", "inch"])
    end
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
    IO.puts output
  end

  defp handle_error(output) do
    IO.puts output
    IO.puts "Inch exited with non-zero result"
  end

end
