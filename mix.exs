defmodule Narou.MixProject do
  use Mix.Project

  def project do
    [
      app: :narou,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:logger]
    ]
  end

  defp deps do
    [
      {:espec, "~> 1.8.2", only: :test},
      {:httpoison, "~>0.11"},
      {:poison, "~> 1.5"},
      {:vex, "~> 0.8"}
    ]
  end
end
