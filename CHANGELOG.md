# Changelog

## 0.4.0 - 2023/03/12

### Breaking changes

+ Require Elixir version `~> 1.14`
+ `Geometry.from_wkb/1` excepts just `binary`. A HEX string must be decoded
  before.
  ```Elixir
  iex> wkb = "00000000013FF0000000000000400199999999999A"
  iex> wkb |> Base.decode16!() |> Geometry.from_wkb()
  {:ok, %Geometry.Point{coordinate: [1.0, 2.2]}}
  ```
+ The functions `Geometry.from_ewkb/` and `Geometry.from_ekwt` are added to work
  with `EWKT`/`EWKB`.
+ The functions `Geometry.to_wkb/2` and `Geometry.to_ewkb/2` do not have an
  option to genrate HEX strings. A HEX string can be created with
  `Base.encode16/1`.

## 0.3.2 - 2022/12/11

+ Refactor `slice` implementations.
+ Add `recode` package.

## 0.3.1 - 2022/01/30

+ Use `Base.encode16/1` and `Base.decode16!/1`
+ Add dep `:prove`
+ Require Elixir version `~> 1.11`

## 0.3.0 - 2020/11/26

## Breaking changes

+ Change return value for `from_wkb` and `from_wkt`.

## 0.2.0 - 2020/11/02

## Breaking changes

+ Add mode (`:hex`/`:binary`) to from_wkb/2 and from_wkb!/2.

## 0.1.0 - 2020/10/18

+ The very first version.
