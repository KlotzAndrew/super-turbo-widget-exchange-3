defmodule WebsocketServer.BroadCastController do
  use WebsocketServer.Web, :controller
  alias WebsocketServer.Endpoint

  def broadcast(conn, %{"message" => message}) do
    Endpoint.broadcast! "room:lobby", "new:message", message
    json conn, %{message: message}
  end
end
