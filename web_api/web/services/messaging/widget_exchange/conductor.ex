defmodule WebApi.Conductor do
  use AMQP

  def exchange, do: "widget_exchange"
  def queue,  do: "widget_queue"
  def queue_error, do: "#{queue()}_error"

  def configure(chan) do
    Confirm.select(chan)
    Basic.qos(chan, prefetch_count: 11)
    Queue.declare(chan, queue_error(), durable: true)
    Queue.declare(chan, queue(), durable: true,
                                arguments: [{"x-dead-letter-exchange", :longstr, ""},
                                            {"x-dead-letter-routing-key", :longstr, queue_error()}])
    Exchange.fanout(chan, exchange(), durable: true)
    Queue.bind(chan, queue(), exchange())
  end
end
