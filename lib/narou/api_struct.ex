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

      @api_types [:novel, :rank, :rankin, :user]

      {validate_info, attributes} = Keyword.split(unquote(attributes), [:validate, :validate_use_value])

      [out_type: :json] ++ attributes |> defstruct

      @type type :: :novel, :rank
      @type out_type :: :json
      @type limit :: 1..500
      @type st :: 1..2000

      validates :type,     inclusion: @api_types
      validates :out_type, inclusion: [:json]

      add_validate_cols = Keyword.get(validate_info, :validate) |> List.wrap()

      if Enum.member?(add_validate_cols, :st) do
        validates :st, number: [greater_than_or_equal_to: 1, less_than_or_equal_to: 2000]
      end

      if Enum.member?(add_validate_cols, :limit) do
        validates :limit, number: [greater_than_or_equal_to: 1,less_than_or_equal_to: 500]
      end

      if Enum.member?(add_validate_cols, :order) do
        validates :order, inclusion: Keyword.get(validate_info, :validate_use_value) |> Keyword.get(:order)
      end

      if Enum.member?(add_validate_cols, :select) do
        validates :select, by: &valid_select?/1
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

  def valid_select?(cols) do
    cols |> Enum.all?(&(is_symbol?(&1)))
  end

  defp is_symbol?(val) do
    is_atom(val) && Regex.match?(~r/^[a-z\d]{1,}([a-z\d\_]*[a-z\d]{1,})*$/, to_string(val))
  end
end