defmodule InchEx.CLI.Commands.ReportCommand do
  @build_api_end_point "https://inch-ci.org/api/v2/builds"

  alias InchEx.CLI.Env
  alias InchEx.CLI.Options
  alias InchEx.CodeObject
  alias InchEx.Docs

  alias InchEx.CLI.Commands.ReportOutput

  @doc false
  def call(argv) do
    if Env.valid?() do
      options = Options.parse(argv)

      options
      |> locate_docs()
      |> fetch_and_evaluate_docs()
      |> send_results(inch_build_api_endpoint())
    else
      ReportOutput.handle_error("InchEx skipped (reason: #{Env.reason_for_invalidity()}).")
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

end
