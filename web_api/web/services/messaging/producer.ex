defmodule WebApi.Producer do
  use AMQP

  @exchange    "widget_exchange"
  @queue       "widget_queue"
  @queue_error "#{@queue}_error"

  def publish(message) do
    {:ok, chan} = :poolboy.transaction(:amqp_pool, fn(worker) -> :gen_server.call(worker, :channel) end)
    Confirm.select(chan)
    Basic.qos(chan, prefetch_count: 10)
    Queue.declare(chan, @queue_error, durable: true)
    Queue.declare(chan, @queue, durable: true,
                                arguments: [{"x-dead-letter-exchange", :longstr, ""},
                                            {"x-dead-letter-routing-key", :longstr, @queue_error}])
    Exchange.fanout(chan, @exchange, durable: true)
    Queue.bind(chan, @queue, @exchange)
    # boiler plate ^^

    Basic.publish(chan, "widget_exchange", "", message, persistent: true)
  end
end
