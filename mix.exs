defmodule Narou.MixProject do
  use Mix.Project

  def project do
    [
      app: :narou,
      version: "0.2.4",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        ignore_warnings: "./dialyzer_ignore.exs",
        list_unused_filters: false #true
      ]
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
      {:httpoison, "~> 1.6"},
      {:poison, "~> 4.0"},
      {:vex, "~> 0.8"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
    ]
  end

  defp aliases do
    [
      test: ["dialyzer", "espec"],
      #compile: ["dialyzer", "compile"]
    ]
  end
end
