defmodule WebApi.Producer do
  use AMQP

  def publish(message) do
    {:ok, chan} = establish_connection()

    Basic.publish(chan, "gen_server_test_exchange", "", message, persistent: true)
  end

  defp establish_connection do
    {:ok, conn} = Connection.open("amqp://guest:guest@haproxy")
    Channel.open(conn)
  end
end
