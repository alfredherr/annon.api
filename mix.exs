defmodule Gateway.Mixfile do
  use Mix.Project

  @version "0.2.9"

  def project do
    [app: :gateway,
     description: "Add description to your package.",
     package: package(),
     version: @version,
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test],
     docs: [source_ref: "v#\{@version\}", main: "readme", extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :confex, :cowboy, :plug, :postgrex, :ecto, :timex, :joken, :nex_json_schema,
                     :poison, :httpoison, :ex_statsd, :skycluster, :eview, :ecto_paging],
      mod: {Gateway, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:distillery, "~> 1.0"},
     {:skycluster, ">= 0.0.0"},
     {:confex, ">= 0.0.0"},
     {:plug, ">= 0.0.0"},
     {:cowboy, ">= 0.0.0"},
     {:postgrex, "~> 0.13"},
     {:ecto, "~> 2.1"},
     {:timex, "~> 3.0"},
     {:poison, "~> 3.1", override: true},
     {:joken, "~> 1.4"},
     {:nex_json_schema, "~> 0.5.1"},
     {:httpoison, ">= 0.0.0"},
     {:ex_statsd, ">= 0.5.1"},
     {:eview,  ">= 0.0.0"},
     {:ecto_paging, ">= 0.0.0"},
     {:phoenix_ecto, ">= 0.0.0"},
     {:ex_machina, ">= 1.0.0", only: [:dev, :test]},
     {:faker, ">= 0.0.0", only: [:dev, :test]},
     {:dogma, ">= 0.0.0", only: [:dev, :test]},
     {:benchfella, "~> 0.3", only: [:dev, :test]},
     {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
     {:cors_plug, "~> 1.1"},
     {:excoveralls, ">= 0.0.0", only: [:dev, :test]},
     {:credo, ">= 0.0.0", only: [:dev, :test]},
    ]
  end

  # Settings for publishing in Hex package manager:
  defp package do
    [contributors: ["Nebo #15"],
     maintainers: ["Nebo #15"],
     licenses: ["LISENSE.md"],
     links: %{github: "https://github.com/Nebo15/os.gateway"},
     files: ~w(lib LICENSE.md mix.exs README.md)]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create --quiet",
                    "ecto.migrate",
                    "run priv/repos/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test":       ["ecto.create --quiet",
                    "ecto.migrate",
                    "test"]]
  end
end
