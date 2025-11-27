defmodule InchEx.Docs do
  @moduledoc """
  Provides functions for loading docs.
  """
  @beam_file_pattern "*.beam"

  def beam_files(files, handle_fn \\ fn file -> file end)

  def beam_files(files, handle_fn) when is_list(files) do
    files
    |> Task.async_stream(handle_fn, timeout: :infinity, ordered: false)
    |> Enum.flat_map(fn {:ok, result} -> result end)
  end

  def beam_files(dir, handle_fn) when is_binary(dir) do
    files = Path.wildcard(Path.expand(@beam_file_pattern, dir))

    beam_files(files, handle_fn)
  end

  @doc "Loads the docs from the given `file`."
  def get_docs(file) do
    file
    |> Code.fetch_docs()
    |> do_get_docs(file)
  end

  defp do_get_docs({:docs_v1, anno, :elixir, _format, moduledoc, metadata, inner_docs}, file) do
    basename =
      file
      |> Path.basename()
      |> String.replace(~r/\.beam$/, "")

    module = String.to_atom(basename)
    module_name = String.replace(basename, ~r/^Elixir\./, "")
    source_root = File.cwd!()

    source =
      module.__info__(:compile)[:source]
      |> String.Chars.to_string()
      |> Path.relative_to(source_root)

    split_module_docs(module_name, source, anno, moduledoc, metadata, inner_docs)
  end

  defp do_get_docs(value, file) do
    IO.inspect(value, label: "Code.fetch_docs/1 failed on file `#{file}`")

    nil
  end

  defp split_module_docs(module_name, source, anno, moduledoc, metadata, inner_docs) do
    module = cast_moduledoc(module_name, source, anno, moduledoc, metadata)
    internals = Enum.map(inner_docs, &cast_doc(&1, module_name, source))

    Enum.reject([module | internals], &private?/1)
  end

  defp cast_moduledoc(module_name, source, anno, moduledoc, metadata) do
    %{
      "type" => "module",
      "name" => module_name,
      "doc" => docstring(moduledoc),
      "metadata" => metadata,
      "location" => "#{source}:#{cast_anno(anno)}"
    }
  end

  defp cast_doc(
         {{kind, name, arity}, anno, signature, doc, metadata},
         module_name,
         source
       ) do
    %{
      "type" => to_string(kind),
      "name" => "#{module_name}.#{name}/#{arity}",
      "signature" => signature,
      "doc" => docstring(doc),
      "metadata" => metadata,
      "location" => "#{source}:#{cast_anno(anno)}"
    }
  end

  defp cast_anno(value) when is_number(value), do: value
  defp cast_anno(value) when is_list(value), do: value[:location]

  defp docstring(%{"en" => docstring}), do: docstring
  defp docstring(:hidden), do: false
  defp docstring(:none), do: nil

  defp private?(%{"doc" => false}), do: true
  defp private?(_), do: false
end
