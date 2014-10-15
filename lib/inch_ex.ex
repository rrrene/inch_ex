# Original code adapted from ExDoc

defmodule InchEx do
  defmodule Config do
    defstruct [
      output: "docs", source_root: nil, source_url: nil, source_url_pattern: nil,
      homepage_url: nil, source_beam: nil, retriever: InchEx.Docs.Retriever,
      formatter: InchEx.Docs.Formatter, project: nil, version: nil, main: nil,
      readme: false, formatter_opts: []
    ]
  end

  defmodule Helper do
    def map_tuple_to_list(tuple) when is_tuple(tuple) do
      map_tuple_to_list Tuple.to_list(tuple)
    end

    def map_tuple_to_list([head | tail]) when is_tuple(head) do
      [map_tuple_to_list(head)] ++ map_tuple_to_list(tail)
    end

    def map_tuple_to_list([head | tail]) when is_list(head) do
      list = Enum.map(head, fn x -> map_tuple_to_list(x) end)
      [list] ++ map_tuple_to_list(tail)
    end

    def map_tuple_to_list([head | tail]) do
      [head] ++ map_tuple_to_list(tail)
    end

    def map_tuple_to_list(value) do
      value
    end
  end

  @doc false
  def generate_docs(project, version, args, options) when is_binary(project) and is_binary(version) and is_list(options) do
    config = build_config(project, version, options)
    docs = config.retriever.docs_from_dir(config.source_beam, config)
    config.formatter.run(docs, args, config)
  end

  defp build_config(project, version, options) do
    options = normalize_options(options)
    preconfig = %Config{
      project: project,
      version: version,
      main: options[:main] || project,
      homepage_url: options[:homepage_url],
      source_root: options[:source_root] || File.cwd!,
    }
    struct(preconfig, options)
  end

  # Helpers

  defp normalize_options(options) do
    pattern = options[:source_url_pattern] || guess_url(options[:source_url], options[:source_ref] || "master")
    Keyword.put(options, :source_url_pattern, pattern)
  end

  defp guess_url(url = <<"https://github.com/", _ :: binary>>, ref) do
    append_slash(url) <> "blob/#{ref}/%{path}#L%{line}"
  end

  defp guess_url(url = <<"https://bitbucket.org/", _ :: binary>>, ref) do
    append_slash(url) <> "src/#{ref}/%{path}#cl-%{line}"
  end

  defp guess_url(other, _) do
    other
  end

  defp append_slash(url) do
    if :binary.last(url) == ?/, do: url, else: url <> "/"
  end
end
