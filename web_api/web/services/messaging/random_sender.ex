defmodule WebApi.RandomSender do
  use GenServer
  import Ecto.Query

  alias WebApi.{Account, Widget, WidgetSender, Repo}

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_opts) do
    GenServer.cast(self(), :xfer)
    {:ok, []}
  end

  def xfer do
    :timer.sleep(1_000)
    account_ids = Repo.all(from a in Account, select: a.id)
    widget = Enum.at(Repo.all(from w in Widget, order_by: w.updated_at, limit: 1), 0)
    available_ids = List.delete(account_ids, widget.account_id)
    WidgetSender.send_widget(widget, Enum.random(available_ids))
    xfer()
  end

  def handle_cast(:xfer, _state) do
    xfer()
    {:noreply, %{}}
  end

  def handle_info(msg, state) do
    IO.inspect(msg, [label: "RandomSender unexpected message!"])
    {:noreply, state}
  end
end
