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

      {validate_info, attributes} = Keyword.split(unquote(attributes), [:validate, :validate_use_value])

      [
        out_type: :json,
        maximum_fetch_mode: false
      ] ++ attributes |> defstruct

      validates :type,     inclusion: Narou.APIStruct.api_types
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

  @spec init(map) :: {:ok, map()} | {:error, binary()}
  def init(opt) do
    {%{type: type}, opt} = Map.split(opt, [:type])

    case type in api_types() do
      true  -> {:ok, type |> gen_struct(opt) }
      false -> {:error, "Unexpected type `#{type}`."}
    end
  end

  defp gen_struct(type, opt) do
    (to_string(__MODULE__) <> "." <> (to_string(type) |> String.capitalize))
    |> String.to_atom
    |> struct
    |> Map.merge(%{type: type})
    |> patch(opt)
  end

  defp patch(struct, opt) do
    struct
    |> patch_st(opt)
    |> patch_limit(opt)
    |> patch_maximum_fetch_mode(opt)
  end

  defp patch_st(struct, %{st: st}) when is_integer(st) do
    struct |> Map.merge(%{st: st })
  end
  defp patch_st(struct, _), do: struct

  defp patch_limit(struct, %{limit: limit}) when is_integer(limit) do
    struct |> Map.merge(%{limit: limit})
  end
  defp patch_limit(struct, _), do: struct

  defp patch_maximum_fetch_mode(struct, %{maximum_fetch_mode: f}) when is_boolean(f) do
    (if f do
      struct |> Map.merge(%{limit: 500})
    else
      struct
    end)
    |> Map.merge(%{maximum_fetch_mode: f})
  end
  defp patch_maximum_fetch_mode(struct, _), do: struct

@doc """
  対応しているAPIタイプのリスト
  """
  @spec api_types() :: list(atom)
  def api_types(), do: [:novel, :rank, :rankin, :user]

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
