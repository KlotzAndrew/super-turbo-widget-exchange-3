defmodule WebApi.RequestProducer do
  use AMQP

  alias WebApi.{RequestConductor}

  def publish(message) do
    {:ok, chan} = :poolboy.transaction(:amqp_pool, fn(worker) -> :gen_server.call(worker, :channel) end)
    RequestConductor.configure(chan)

    Basic.publish(chan, RequestConductor.exchange(), "", message, persistent: true)
  end
end
