defmodule InchEx.Env do
  @doc "Returns true if run on arbitrary machine."
  def unknown? do
    !circleci? && !travis? && !unknown_ci?
  end

  @doc "Returns true if not run on any known CI, but seems to be on CI."
  def unknown_ci? do
    !circleci? && !travis? && System.get_env("CI") == "true"
  end

  @doc "Returns true if run on CircleCI."
  def circleci? do
    System.get_env("CIRCLECI") == "true"
  end

  @doc "Returns true if run on Travis."
  def travis? do
    System.get_env("TRAVIS") == "true"
  end
end
