defmodule Narou.Entity do
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
    use Narou.Entity, hoge: "", limit: 1, validate: [:limit]
  end
"""
  defmacro __using__(attributes) do
    quote do
      import Narou.Entity
      use Vex.Struct

      {validate_info, attributes} = Keyword.split(unquote(attributes), [:validate, :validate_use_value])

      [
        type: nil,
        out_type: :json,
        maximum_fetch_mode: false
      ] ++ attributes |> defstruct

      validates :type,     inclusion: Narou.Entity.api_types
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

      def __drop_keys__, do: [:__struct__, :maximum_fetch_mode]
      defoverridable __drop_keys__: 0
    end
  end

  @spec init(keyword()) :: {:ok, map()} | {:error, binary()}
  def init(opt) do
    {[type: type], opt} = Keyword.split(opt, [:type])

    case type in api_types() do
      false -> {:error, "Unexpected type `#{type}`."}
      true  ->
        gen_struct(type, opt)
        |> validate()
    end
  end

  defp gen_struct(type, opt) do
    to_submodule(type)
    |> struct(type: type)
    |> patch(opt)
  end

  defp to_submodule(type) do
    ("#{__MODULE__}" <> "." <> ("#{type}" |> String.capitalize))
    |> String.to_atom
  end

  defp patch(struct, opt) do
    struct
    |> patch_st(Keyword.get(opt, :st))
    |> patch_limit(Keyword.get(opt, :limit))
    |> patch_maximum_fetch_mode(Keyword.get(opt, :maximum_fetch_mode))
  end

  defp patch_st(struct, st) when is_integer(st), do: %{struct | st: st}
  defp patch_st(struct, _), do: struct

  defp patch_limit(struct, limit) when is_integer(limit), do: %{struct | limit: limit}
  defp patch_limit(struct, _), do: struct

  defp patch_maximum_fetch_mode(struct, mode) when is_boolean(mode) do
    (if mode do
      %{struct | limit: 500}
    else
      struct
    end)
    |> Map.merge(%{maximum_fetch_mode: mode})
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
    cols |> Enum.all?(&is_symbol?/1)
  end

  defp is_symbol?(val) do
    is_atom(val) && Regex.match?(~r/^[a-z\d]{1,}([a-z\d\_]*[a-z\d]{1,})*$/, to_string(val))
  end

  def to_map_for_build_query(entity), do: Map.drop(entity, to_submodule(entity.type).__drop_keys__)
end
