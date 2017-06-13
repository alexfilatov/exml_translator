defmodule ExmlTranslator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exml_translator,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: apps(Mix.env)]
  end

  defp apps(:prod) do
    [:logger, :goth, :gcloudex, :erlsom]
  end

  defp apps(:dev) do
    apps(:prod) ++ [:remix]
  end

  defp apps(:test) do
    apps(:dev)
  end


  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 3.1", override: true},
      {:goth, git: "https://github.com/alexfilatov/goth.git", override: true},
      {:gcloudex, git: "https://github.com/alexfilatov/gcloudex.git"},
      {:remix, git: "https://github.com/sgtpepper43/remix.git"},
      {:erlsom, git: "git@github.com:willemdj/erlsom.git"}
    ]
  end
end
