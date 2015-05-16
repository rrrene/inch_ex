defmodule InchEx.GitHub do
  def open_source?("https://github.com/" <> slug) do
    nwo = String.replace(slug, ~r/\.git$/, "")
    case github_repo_info(nwo) do
      {:ok, json} -> json["private"] == false
      _ -> false
    end
  end

  def open_source?(_) do
    false
  end

  defp github_repo_info(nwo) do
    case :httpc.request(:get, {'https://api.github.com/repos/#{nwo}', [{'User-Agent', 'inch_ex'}]}, [], []) do
      {:ok, {_, _, body}} ->
        {:ok, Poison.decode!(body)}
      _ -> {:error}
    end
  end
end
