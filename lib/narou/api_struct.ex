defmodule Narou.APIStruct do
@moduledoc """
APIデータの基底モジュール。
"""

@doc """
APIデータの共通処理。

## param
  - validate: list(symbol) : バリデーションを追加したいカラムリストを指定する。 [:st, :limit]
  - hoge_attr: default_val : 追加したいプロパティと初期値を指定する。

## EXAMPLE

  defmodule MyStruct
    use Narou.APIStruct, hoge: "", limit: 1, validate: [:limit]
  end
"""
  defmacro __using__(attributes) do
    quote do
      import Narou.APIStruct
      use Vex.Struct

      @api_types [:novel, :rank]
      @out_types [:json, :yaml]

      {[{:validate, add_validate_cols}], attributes} = Keyword.split(unquote(attributes), [:validate])

      [out_type: List.first(@out_types)] ++ attributes |> defstruct

      @type type :: :novel, :rank
      @type out_type :: :json | :yaml
      @type limit :: 1..500
      @type st :: 1..2000

      validates :type,     inclusion: @api_types
      validates :out_type, inclusion: @out_types

      if Enum.member?(add_validate_cols, :st) do
        validates :st,       number: [greater_than_or_equal_to: 1, less_than_or_equal_to: 2000]
      end

      if Enum.member?(add_validate_cols, :limit) do
        validates :limit,    number: [greater_than_or_equal_to: 1,less_than_or_equal_to: 500]
      end
    end
  end

  @spec validate(map) :: {:ok, map} | {:error, {:error, any}}
  def validate(s) do
    case valid?(s) do
      true ->  {:ok, s}
      false -> {:error, errors(s)}
    end
  end

  defp valid?(s) when is_struct(s) do
    s.__struct__.valid?(s)
  end

  defp errors(s) do
    Vex.errors(s)
  end
end