defmodule WebApi.Consumer do
  use GenServer
  use AMQP

  alias WebApi.{Conductor, Widget, Repo, WebsocketClient}

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

    Conductor.configure(chan)

    {:ok, _consumer_tag} = Basic.consume(chan, Conductor.queue())
    {:noreply, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    IO.puts "Consumer connected"
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    IO.puts "Consumer unexpectedly disconnected"
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    IO.puts "Consumer Basic.cancel"
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    IO.puts "Consumer Basic.deliver"
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end

  def handle_info(msg, state) do
    IO.puts "Consumer unexpected message #{msg}!"
    :erlang.send_after(5000,self(), :listen)
    {:noreply, state}
  end

  defp consume(channel, tag, redelivered, payload) do
    decoded_params = Poison.decode!(payload)
    widget_params  = decoded_params["widget"]
    changeset      = Widget.changeset(%Widget{}, widget_params)

    case Repo.insert(changeset) do
      {:ok, widget} ->
        WebsocketClient.broadcast_widget(:received, widget)
        Basic.ack channel, tag
      {:error, _changeset} ->
        Basic.reject channel, tag, requeue: false
    end

  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise comsumer will stop
    # receiving messages.
    exception ->
      IO.inspect exception
      Basic.reject channel, tag, requeue: not redelivered
      IO.puts "WebApi.Consumer ERROR converting #{payload}"
  end
end
