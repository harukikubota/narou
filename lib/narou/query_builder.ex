defmodule Narou.QueryBuilder do

  alias Narou.ApiKeyNameConverter, as: C

  @query_start_str   "?"
  @col_delimita      "&"
  @key_val_delimita  "="
  @in_value_delimita "-"

  @spec build(map) :: binary
  def build(map) do
    map |> Map.drop([:__struct__])
    |> Enum.map(fn {k, v} -> convert_to_queries(Map.get(map, :type), k, v) end)
    |> Enum.flat_map(&(List.wrap(&1)))
    |> to_query
  end

  @spec convert_to_queries(atom, atom, any) :: list(binary)
  defp convert_to_queries(type, key, val) do
    convert_for(type, key, val)
    |> List.wrap
  end

  defp convert_for(_, :out_type, val), do: {:out, convert_val(val)}
  defp convert_for(:novel, :type, _),  do: {:_uri, "/novelapi/api" }
  defp convert_for(:rank, :type, _),   do: {:_uri, "/rank/rankget" }
  defp convert_for(:rankin, :type, _), do: {:_uri, "/rank/rankin" }
  defp convert_for(:user, :type, _),   do: {:_uri, "/userapi/api" }

  # Novel
  defp convert_for(:novel, :st, val),     do: {:st, convert_val(val)}
  defp convert_for(:novel, :limit, val),  do: {:lim, convert_val(val)}
  defp convert_for(:novel, :select, val), do: {:of, (val |> C.exec(:novel) |> convert_val) }
  defp convert_for(:novel, :order, val),  do: {:order, convert_val(val)}
  defp convert_for(:novel, :where, val),  do: val |> Enum.map(fn {k, v} -> {k, convert_val(v)} end)

  # Rank
  defp convert_for(:rank, :where, %{y: y, m: m, d: d, t: rtype}) do
    date = [y, m, d] |> Enum.map(&(String.pad_leading(to_string(&1), 2, "0"))) |> Enum.join

    {:rtype, (date <> @in_value_delimita <> to_string(rtype))}
  end

  # Rankin
  defp convert_for(:rankin, :where, %{ncode: ncode}), do: {:ncode, ncode}

  # User
  defp convert_for(:user, :st, val),     do: {:st, convert_val(val)}
  defp convert_for(:user, :limit, val),  do: {:lim, convert_val(val)}
  defp convert_for(:user, :select, val), do: {:of, (val |> C.exec(:user) |> convert_val) }
  defp convert_for(:user, :order, val),  do: {:order, convert_val(val)}
  defp convert_for(:user, :where, val),  do: val |> Enum.map(fn {k, v} -> {k, convert_val(v)} end)

  defp convert_for(type, not_allowed_key, _), do: raise "Unexpected key `#{not_allowed_key}` for #{type}."

  defp convert_val(val) when is_integer(val), do: to_string(val)
  defp convert_val(val) when is_binary(val),  do: val
  defp convert_val(val) when is_atom(val),    do: to_string(val)
  defp convert_val(val) when is_list(val),    do: Enum.join(val, @in_value_delimita)

  defp to_query(query_list) do
    {[_uri: uri], params } = query_list |> Keyword.split([:_uri])

    query = params
      |> Enum.map(&(join_col(&1)))
      |> drop_blank_val()
      |> Enum.join(@col_delimita)

    uri <> @query_start_str <> query
  end

  defp join_col(col) do
    {key, val} = col

    unless is_empty?(val), do: to_string(key) <> @key_val_delimita <> to_string(val), else: ""
  end

  defp drop_blank_val(arr) do
    grouped = arr |> Enum.group_by(&String.length/1)
    case Map.has_key?(grouped, 0) do
      true  -> Map.delete(grouped, 0) |> Map.values |> Enum.map(&(Enum.at(&1,0)))
      false -> arr
    end
  end

  defp is_empty?(v) when is_list(v),   do: length(v) == 0
  defp is_empty?(v) when is_binary(v), do: String.length(v) == 0
  defp is_empty?(v) when is_map(v),    do: map_size(v) == 0
  defp is_empty?(_),                   do: false
end
