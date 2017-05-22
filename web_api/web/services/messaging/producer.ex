defmodule WebApi.Producer do
  use AMQP

  def publish(message) do
    {:ok, conn} = establish_connection()
    {:ok, chan} = establish_channel(conn)

    Basic.publish(chan, "widget_exchange", "", message, persistent: true)

    Connection.close(conn)
  end

  defp establish_connection do
    Connection.open("amqp://guest:guest@haproxy")
  end

  defp establish_channel(conn) do
    Channel.open(conn)
  end
end
