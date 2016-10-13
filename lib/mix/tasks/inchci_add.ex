defmodule Mix.Tasks.Inchci.Add do
  use Mix.Task

  @shortdoc "Add the project to inch-ci.org"
  @recursive true

  @inch_ex_github_url Mix.Project.config[:source_url]
  @not_github_error """
  Currently, only open source projects hosted on GitHub can be added to
  https://inch-ci.org

  If your project is actually hosted on GitHub and this is an error or
  if you want to propose another hosting service to be added, please open
  an issue: #{@inch_ex_github_url}
  """

  @doc false
  def run(_) do
    InchEx.Setup.print_heading "Adding project to Inch CI ..."
    if InchEx.GitHub.open_source?(InchEx.Git.repo_https_url) do
      add_to_inch_ci()
    else
      InchEx.Setup.print @not_github_error
    end
  end

  defp add_to_inch_ci do
    case Mix.Tasks.Inch.Report.run([]) do
      {:ok, output} -> InchEx.Setup.run(output)
      {:error} -> nil
    end
  end
end
