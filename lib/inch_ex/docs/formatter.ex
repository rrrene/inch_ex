defmodule InchEx.Docs.Formatter do
  @moduledoc """
  Provide JSON-formatted documentation
  """

  @doc """
  Generate JSON documentation for the given modules
  """
  def run(modules, config)  do
    output = Path.expand(config.output)
    :ok = File.mkdir_p output

    list = all(modules) # |> Enum.map(fn(x) -> Map.to_list(x) end)
    data = [objects: list]

    if System.get_env("TRAVIS") == "true" do
      data = Keyword.put(data, :travis, true)
      data = Keyword.put(data, :travis_job_id, System.get_env("TRAVIS_JOB_ID"))
      data = Keyword.put(data, :travis_commit, System.get_env("TRAVIS_COMMIT"))
      data = Keyword.put(data, :travis_repo_slug, System.get_env("TRAVIS_REPO_SLUG"))
    else
      # IO.puts "Not Travis!!"
    end

    save_as_json(output, data, config)
    Path.join(config.output, "all.json")
  end

  defp all(modules) do
    project_funs = for m <- modules, d <- m.docs, do: fun(m, d)
    project_modules = for m <- modules, do: mod(m)
    Enum.concat(project_modules, project_funs)
  end

  defp fun(module, func) do
    list = Map.to_list(func)
    list = Keyword.put(list, :module_id, inspect(module.module))
    list = Keyword.put(list, :object_type, list[:__struct__] |> inspect |> object_type)
    list = Keyword.delete(list, :__struct__)
    list = Keyword.delete(list, :docs)
    list
  end

  defp mod(module) do
    list = Map.to_list(module)
    list = Keyword.put(list, :object_type, list[:__struct__] |> inspect |> object_type)
    list = Keyword.delete(list, :__struct__)
    list = Keyword.delete(list, :docs)
    list
  end

  defp save_as_json(output, data, config) do
    {:ok, json} = JSON.encode(data)
    :ok = File.write("#{output}/all.json", json)
  end

  defp object_type(str) do
    String.replace(str, "InchEx.", "")
  end
end
