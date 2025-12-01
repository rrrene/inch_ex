defmodule InchEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :inch_ex,
      version: "2.1.0",
      elixir: ">= 1.15.0",
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
    ] ++ project_cli_entry()
  end

  defp preferred_cli_env do
    ["test.watch": :test]
  end

  if Version.match?(System.version(), ">= 1.19.0-dev") do
    defp project_cli_entry do
      []
    end

    def cli do
      [preferred_cli_env: preferred_cli_env()]
    end
  else
    defp project_cli_entry do
      [preferred_cli_env: preferred_cli_env()]
    end
  end

  def application do
    [mod: {InchEx.Application, []}, applications: [:bunt, :logger, :inets, :jason]]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:bunt, "~> 1.0"},
      {:credo, "~> 1.7", only: :dev},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
