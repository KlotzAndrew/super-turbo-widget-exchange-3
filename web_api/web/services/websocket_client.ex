defmodule WebApi.WebsocketClient do
  def host_url, do: System.get_env("WS_HOST") || "websocket_server"

  def broadcast_widget(:sent, widget) do
    HTTPoison.post(
      "http://#{host_url()}:5000/api/broadcasts",
      encode_widget_broadcast(:sent, widget),
      [{"Content-Type", "application/json"}]
    )
  end

  def broadcast_widget(:received, widget) do
    HTTPoison.post(
      "http://#{host_url()}:5000/api/broadcasts",
      encode_widget_broadcast(:received, widget),
      [{"Content-Type", "application/json"}]
    )
  end

  defp encode_widget_broadcast(:sent, widget) do
    Poison.encode!(%{
      message: %{
        status: "sent",
        widget: serialize_widget(widget)
      }
    })
  end

  defp encode_widget_broadcast(:received, widget) do
    Poison.encode!(%{
      message: %{
        status: "received",
        widget: serialize_widget(widget)
      }
    })
  end

  defp serialize_widget(widget) do
    %{
      account_id: widget.account_id,
      token:      widget.token,
      id:         widget.id
    }
  end
end
