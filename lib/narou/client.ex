defmodule Narou.Client do
  require Logger

  defstruct endpoint: nil

  @http_client HTTPoison

  @spec init(binary) :: %__MODULE__{}
  def init(endpoint \\ "https://api.syosetu.com") do
    @http_client.start
    %__MODULE__{endpoint: endpoint}
  end

  @spec run(%__MODULE__{}, binary) :: {:ok, any} | {:error, any}
  def run(client, query) do
    logging_url = fn url ->
                    Logger.debug "from Narou.Client request to `#{url}'"
                    url
                  end

    url(client.endpoint, query)
    |> logging_url.()
    |> send!
  end
  defp url(ep, q), do: ep <> q
  defp send!(url) do
    try do
      @http_client.get!(url, [], [recv_timeout: 3000])
    rescue
      e in HTTPoison.Error ->
        case e.reason do
          :timeout -> send!(url)
          _ -> e
        end
    end
  end
end
