defmodule InchEx.CLI.Commands.ReportOutput do
  alias InchEx.CLI.Git

  @doc false
  def call(results, url) do
    results
    |> InchEx.JSON.Mapping.from_results()
    |> merge_metadata
    |> InchEx.JSON.encode!()
    |> send_to_server(url)
  end

  defp send_to_server(data, url) do
    case :httpc.request(:post, {url, [], 'application/json', data}, [], []) do
      {:ok, {_, _, body}} ->
        handle_success(body)

      {:error, {:failed_connect, _}} ->
        handle_error("InchEx failed to connect to #{url}")

      {:error, {:failed_connect, _, _}} ->
        handle_error("InchEx failed to connect to #{url}")

      error ->
        handle_error("InchEx failed.")
        handle_error(inspect(error, pretty: true))
    end
  end

  def handle_error(value) do
    IO.puts(value)
  end

  def handle_success(response) do
    IO.puts("InchEx succeeded.")
    IO.puts(inspect(response, pretty: true))
  end

  defp merge_metadata(map) do
    metadata = %{
      "language" => "elixir",
      "client_name" => "inch_ex",
      "client_version" => InchEx.version(),
      "branch_name" => Git.branch_name(),
      "git_repo_url" => Git.repo_https_url(),
      "revision" => Git.revision()
    }

    Map.merge(map, metadata)
  end
end
