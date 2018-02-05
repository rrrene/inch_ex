defmodule InchEx.Git do
  @moduledoc """
    Provide information about the Git repo in the cwd.
  """

  @doc """
    Returns true if there are any modified or untracked files in the
    working dir.
  """
  def dirty? do
    git_output(["status", "--porcelain"]) != ""
  end

  @doc "Returns the https git URL of the repo."
  def repo_https_url do
    origin_url() |> rewrite_git_ssh_url_to_https()
  end

  @doc "Returns the git URL of the repo."
  def origin_url do
    git_output(["ls-remote", "--get-url", "origin"])
  end

  @doc "Returns the name of the current branch."
  def branch_name do
    git_output(["rev-parse", "--abbrev-ref", "HEAD"])
  end

  @doc "Returns the SHA1 of the current revision."
  def revision do
    git_output(["rev-parse", "HEAD"])
  end

  defp git_output(args) do
    case System.cmd("git", args) do
      {output, 0} -> String.trim(output)
      {output, _} -> String.trim(output)
    end
  end

  defp rewrite_git_ssh_url_to_https(url) do
    String.replace(url, "git@github.com:", "https://github.com/")
  end
end
