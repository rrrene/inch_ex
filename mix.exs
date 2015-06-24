defmodule InchEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :inch_ex,
      version: "0.3.3",
      elixir: "~> 1.0",
      description: "Elixir wrapper for Inch",
      source_url: "https://github.com/rrrene/inch_ex",
      package: [
        contributors: ["René Föhring"],
        licenses: ["MIT"],
        links: %{
         "GitHub" => "https://github.com/rrrene/inch_ex",
        }
      ],
      deps: deps
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
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
      {:poison, "~> 1.2"}
    ]
  end
end
