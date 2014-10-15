defmodule InchEx.Docs.Formatter do
  @moduledoc """
  Provide JSON-formatted documentation
  """

  @doc """
  Generate JSON documentation for the given modules
  """
  def run(modules, args, config)  do
    output = Path.expand(config.output)
    :ok = File.mkdir_p output

    list = all(modules) # |> Enum.map(fn(x) -> Map.to_list(x) end)
    data = %{:language => "elixir", :args => args, :objects => list}
    data = Map.put(data, :git_repo_url, git_repo_url)

    if System.get_env("TRAVIS") == "true" do
      data = Map.put(data, :travis, true)
      data = Map.put(data, :travis_job_id, System.get_env("TRAVIS_JOB_ID"))
      data = Map.put(data, :travis_commit, System.get_env("TRAVIS_COMMIT"))
      data = Map.put(data, :travis_repo_slug, System.get_env("TRAVIS_REPO_SLUG"))
      data = Map.put(data, :travis_branch, System.get_env("TRAVIS_BRANCH"))
    else
      # IO.puts "Not Travis!!"
    end

    save_as_json(output, data, config)
    Path.join(config.output, "all.json")
  end

  defp git_repo_url do
    case System.cmd("git", ["ls-remote", "--get-url", "origin"]) do
      {output, 0} -> String.strip(output)
      {output, _} -> String.strip(output)
    end
  end

  defp all(modules) do
    project_funs = for m <- modules, d <- m.docs, do: fun(m, d)
    project_modules = for m <- modules, do: mod(m)
    Enum.concat(project_modules, project_funs)
  end

  defp fun(module, func) do
    o_type = Map.get(func, :__struct__) |> inspect |> object_type
    list = Map.delete(func, :__struct__)
    list = Map.put(list, :module_id, inspect(module.module))
    list = Map.put(list, :object_type, o_type)
    list = Map.delete(list, :docs)
    list
  end

  defp mod(module) do
    o_type = Map.get(module, :__struct__) |> inspect |> object_type
    list = Map.delete(module, :__struct__)
    list = Map.put(list, :object_type, o_type)
    list = Map.delete(list, :docs)
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
