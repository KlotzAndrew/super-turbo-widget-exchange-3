defmodule WebApi.AMQPPool do
  use GenServer
  use AMQP

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_opts) do
    :erlang.send(self(), :connect)
    {:ok, []}
  end

  def handle_info(:connect, state) do
    handle_rabbit_connect(AMQP.Connection.open("amqp://guest:guest@haproxy"), state)
  end

  def handle_rabbit_connect({:error, _}, _state) do
    IO.puts("Error connecting to rabbit")
    :erlang.send_after(5000, self(), :connect)
    {:noreply, nil}
  end

  def handle_rabbit_connect({:ok, conn}, _state) do
    %AMQP.Connection{pid: pid} = conn
    Process.link(pid)
    Process.flag(:trap_exit, true)
    IO.puts("Connected to rabbit")
    {:noreply, pid}
  end

  def handle_call(:channel, _from, state) do
    conn = %AMQP.Connection{pid: state}
    {:ok, channel} = AMQP.Channel.open(conn)
    {:reply, {:ok, channel}, state}
  end

  def handle_info(msg, state) do
    IO.puts "Consumer unexpected message #{msg}!"
    IO.inspect msg
    {:noreply, state}
  end
end
