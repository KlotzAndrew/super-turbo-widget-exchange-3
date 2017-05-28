defmodule WebApi.RequestConsumer do
  use GenServer
  use AMQP

  alias WebApi.{RequestConductor, Widget, Repo, WebsocketClient, Producer}

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_opts) do
    :erlang.send_after(5000, self(), :listen)
    {:ok, []}
  end

  def handle_info(:listen, _state) do
    {:ok, chan} = :poolboy.transaction(:amqp_pool, fn(worker) -> :gen_server.call(worker, :channel) end)
    Process.monitor(chan.pid)
    Process.flag(:trap_exit, true)

    RequestConductor.configure(chan)

    {:ok, _consumer_tag} = Basic.consume(chan, RequestConductor.queue())
    {:noreply, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    IO.puts "RequestConsumer connected"
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    IO.puts "RequestConsumer unexpectedly disconnected"
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    IO.puts "RequestConsumer Basic.cancel"
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    IO.puts "RequestConsumer Basic.deliver"
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end

  def handle_info(msg, state) do
    IO.puts "RequestConsumer unexpected message"
    IO.inspect msg
    :erlang.send_after(5000,self(), :listen)
    {:noreply, state}
  end

  defp consume(channel, tag, redelivered, payload) do
    decoded_params = Poison.decode!(payload)
    widget_params  = decoded_params["widget_request"]
    to_id          = widget_params["to_id"]
    widget         = Repo.get(Widget, widget_params["id"])

    delete_widget(widget, to_id)
    Basic.ack channel, tag
  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise comsumer will stop
    # receiving messages.
    exception ->
      IO.puts "an error pusing request!"
      IO.inspect exception
      Basic.reject channel, tag, requeue: not redelivered
      IO.puts "WebApi.WebsocketClient ERROR converting #{payload}"
  end

  defp delete_widget(nil, _to_id), do: IO.puts("Already deleted!")
  defp delete_widget(widget, to_id) do
    Repo.delete!(widget)

    request = Producer.publish(encode_widget(widget.token, to_id))
    WebsocketClient.broadcast_widget(:sent, widget)
    IO.puts "RequestConsumer boadcasting :sent!"
    IO.inspect request
  end

  defp encode_widget(token, to_id) do
    Poison.encode!(%{widget:
      %{token: token, account_id: to_id}
    })
  end
end
