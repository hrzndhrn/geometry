defmodule Geometry.MixProject do
  use Mix.Project

  def project do
    [
      app: :geometry,
      name: "Geometry",
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      dialyzer: dialyzer(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      aliases: aliases(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def elixirc_paths(env) do
    case env do
      :test -> ["lib", "test/support"]
      _ -> ["lib"]
    end
  end

  defp preferred_cli_env do
    [
      carp: :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.travis": :test,
      "geometry.gen": :test
    ]
  end

  defp aliases do
    [
      carp: ["test --seed 0 --max-failures 1"],
      "geometry.gen": ["run script/gen_from_zm.exs", "test"]
    ]
  end

  defp docs do
    [
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
      # ignore_warnings: ".dialyzer_ignore.exs",
      plt_add_apps: [:nimble_parsec],
      plt_file: {:no_warn, "test/support/plts/dialyzer.plt"},
      flags: [:unmatched_returns]
    ]
  end

  defp deps do
    [
      {:nimble_parsec, "~> 0.5 or ~> 1.0"},
      # test and dev
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test, runtime: false},
      {:jason, "~> 1.2", only: [:dev, :test]},
      {:xema, "~> 0.13.1", only: :test}
    ]
  end
end
