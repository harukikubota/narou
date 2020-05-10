defmodule Narou.Client do
  defstruct endpoint: nil

  @http_client HTTPoison

  @spec init(binary) :: %__MODULE__{}
  def init(endpoint \\ "https://api.syosetu.com") do
    @http_client.start
    %__MODULE__{endpoint: endpoint}
  end

  @spec run(%__MODULE__{}, binary) :: {:ok, any} | {:error, any}
  def run(client, query), do: url(client.endpoint, query) |> send!
  defp url(ep, q), do: ep <> q
  defp send!(url), do: @http_client.get!(url)
end
