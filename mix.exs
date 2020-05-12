defmodule Narou.MixProject do
  use Mix.Project

  def project do
    [
      app: :narou,
      version: "0.2.1",
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
      {:distillery, "~> 2.0"},
      {:espec, "~> 1.8.2", only: :test},
      {:httpoison, "~>0.11"},
      {:poison, "~> 4.0"},
      {:vex, "~> 0.8"}
    ]
  end
end
