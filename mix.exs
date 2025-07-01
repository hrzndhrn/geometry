defmodule Geometry.MixProject do
  use Mix.Project

  @version "1.1.0"
  @source_url "https://github.com/hrzndhrn/geometry"

  def project do
    [
      app: :geometry,
      name: "Geometry",
      version: @version,
      elixir: "~> 1.15",
      description: "A set of geometry types for WKT/EWT, WKB/EWKB and GeoJson.",
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      dialyzer: dialyzer(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      package: package(),
      aliases: aliases(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def cli do
    [
      preferred_envs: [
        carp: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.github": :test,
        "geometry.gen": :test
      ]
    ]
  end

  def elixirc_paths(env) do
    case env do
      :test -> ["lib", "test/support"]
      _ -> ["lib"]
    end
  end

  defp aliases do
    [
      carp: ["test --seed 0 --max-failures 1"]
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md"],
      source_url: @source_url,
      source_ref: "v#{@version}",
      main: Geometry,
      formatters: ["html"],
      groups_for_modules: [
        "Geometry primitives 2D": [
          Geometry.LineString,
          Geometry.LineStringM,
          Geometry.Polygon,
          Geometry.PolygonM,
          Geometry.Point,
          Geometry.PointM
        ],
        "Geometry primitives 3D": [
          Geometry.LineStringZ,
          Geometry.LineStringZM,
          Geometry.PolygonZ,
          Geometry.PolygonZM,
          Geometry.PointZ,
          Geometry.PointZM
        ],
        "Multipart geometries 2D": [
          Geometry.MultiLineString,
          Geometry.MultiLineStringM,
          Geometry.MultiPoint,
          Geometry.MultiPointM,
          Geometry.MultiPolygon,
          Geometry.MultiPolygonM
        ],
        "Multipart geometries 3D": [
          Geometry.MultiLineStringZ,
          Geometry.MultiLineStringZM,
          Geometry.MultiPointZ,
          Geometry.MultiPointZM,
          Geometry.MultiPolygonZ,
          Geometry.MultiPolygonZM
        ],
        "Geometries collection 2D": [
          Geometry.GeometryCollection,
          Geometry.GeometryCollectionM
        ],
        "Geometries collection 3D": [
          Geometry.GeometryCollectionZ,
          Geometry.GeometryCollectionZM
        ],
        GeoJson: [
          Geometry.Feature,
          Geometry.FeatureCollection
        ]
      ]
    ]
  end

  defp dialyzer do
    [
      flags: [:unmatched_returns, :error_handling],
      plt_file: {:no_warn, "test/support/plts/dialyzer.plt"},
      ignore_warnings: ".dialyzer_ignore.exs",
      plt_ignore_apps: [
        :benchee,
        :benchee_dsl,
        :benchee_markdown,
        :deep_merge,
        :eex,
        :geo,
        :jason
      ]
    ]
  end

  defp deps do
    [
      {:nimble_parsec, "~> 0.5 or ~> 1.0"},
      # dev and test
      {:beam_file, "~>0.4", only: :dev},
      {:benchee_dsl, "~> 0.1", only: :dev},
      {:benchee_markdown, "~> 0.2", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14", only: :test, runtime: false},
      {:geo, "~> 4.0", only: :dev},
      {:jason, "~> 1.3", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false},
      {:prove, "~> 0.1", only: [:dev, :test]},
      {:recode, "~> 0.4", only: :dev},
      {:xema, "~> 0.15", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Marcus Kruse"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ]
    ]
  end
end
