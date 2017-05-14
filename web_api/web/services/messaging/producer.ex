defmodule WebApi.Producer do
  use AMQP

  def publish(message) do
    {:ok, chan} = establish_connection()

    Basic.publish chan, "gen_server_test_exchange", "", message
  end

  defp establish_connection do
    {:ok, conn} = Connection.open("amqp://guest:guest@rabbitmq")
    Channel.open(conn)
  end
end
