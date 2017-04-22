# Original code adapted from ExDoc

defmodule Mix.Tasks.Inch do
  use Mix.Task

  @shortdoc "Show documentation evaluation for the project"
  @version Mix.Project.config[:version]
  @recursive true

  @doc false
  def run(args, config \\ Mix.Project.config, generator \\ &InchEx.generate_docs/4, reporter \\ InchEx.Reporter.Local) do
    Mix.Task.run "compile"

    case args do
      ["-v"] -> print_version()
      ["--version"] -> print_version()
      _ -> nil
    end

    project = (config[:name] || config[:app]) |> to_string
    version = config[:version] || "dev"
    options = get_docs_opts(config)

    options =
      if source_url = config[:source_url] do
        Keyword.put(options, :source_url, source_url)
      else
        options
      end

    options =
      cond do
        is_nil(options[:main]) ->
          # Try generating main module's name from the app name
          Keyword.put(options, :main, (config[:app] |> Atom.to_string |> Macro.camelize))

        is_atom(options[:main]) ->
          Keyword.update!(options, :main, &inspect/1)

        is_binary(options[:main]) ->
          options
      end

    options = Keyword.put_new(options, :source_beam, Mix.Project.compile_path)
    options = Keyword.put_new(options, :retriever, InchEx.Docs.Retriever)
    options = Keyword.put_new(options, :formatter, InchEx.Docs.Formatter)

    json_filename = generator.(project, version, args, options)
    reporter.run(json_filename, args)
  end

  defp get_docs_opts(config) do
    docs = config[:docs]
    cond do
      is_function(docs, 0) -> docs.()
      is_nil(docs) -> []
      true -> docs
    end
  end

  defp print_version do
    IO.puts "inch_ex #{@version}"
  end
end
