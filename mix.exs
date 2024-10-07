defmodule FlameTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :flame_test,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        flame_test: [
          include_executables_for: [:unix],
          include_erts: true,
          cookie: "secret"
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FlameTest.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:flame, "~> 0.5.1"},
      {:flame_k8s_backend, "~> 0.5.4"},
      {:yaml_elixir, "~> 2.11.0"},
      {:plug, "~> 1.14"},
      {:bandit, "~> 1.0-pre.10"},
      {:jason, "~> 1.0"}
    ]
  end
end
