defmodule WebApi.Producer do
  use AMQP

  alias WebApi.{Conductor}

  def publish(message) do
    {:ok, chan} = :poolboy.transaction(:amqp_pool, fn(worker) -> :gen_server.call(worker, :channel) end)
    Conductor.configure(chan)

    Basic.publish(chan, "widget_exchange", "", message, persistent: true)
    Channel.close(chan)
  end
end
