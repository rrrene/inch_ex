defmodule InchEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :inch_ex,
      version: "2.1.0-rc.1",
      elixir: ">= 1.7.0",
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

  def application do
    [mod: {InchEx.Application, []}, applications: [:bunt, :logger, :inets, :jason]]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:bunt, "~> 0.2"},
      {:credo, "~> 1.6", only: :dev}
    ]
  end
end
