defmodule InchEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :inch_ex,
      version: "2.0.0-rc2",
      elixir: "~> 1.7.0-dev",
      description: "Provides a Mix task that gives you hints where to improve your inline docs",
      source_url: "https://github.com/rrrene/inch_ex",
      package: [
        maintainers: ["René Föhring"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/rrrene/inch_ex"
        }
      ],
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {InchEx.Application, []}, applications: [:bunt, :logger, :inets]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:jason, "~> 1.0"},
      {:bunt, "~> 0.2"},
      {:credo, "~> 0.10", only: :dev}
    ]
  end
end
