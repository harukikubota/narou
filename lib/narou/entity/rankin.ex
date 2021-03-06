defmodule Narou.Entity.Rankin do
  @moduledoc """

  小説殿堂入りAPI用データ。
  """

  import Narou.Util
  use Narou.Entity, where: %{ncode: "N0000A"}

  validates :where, by: &__MODULE__.valid_where?/1

  def valid_where?(map) do
    {%{ncode: ncode}, other} = Map.split(map, [:ncode])

    cond do
      map_size(other) > 0 -> {:error, "Unexpected keys [#{inspect(Map.keys(other))}]"}

      !is_ncode(ncode) -> {:error, "invalid NCode `#{ncode}`."}

      true -> true
    end
  end
end
