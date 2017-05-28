defmodule WebApi.WidgetSender do
  import Ecto.Query
  alias WebApi.{Widget, Repo, RequestProducer}

  def transfer_all(id, to_id) do
    widgets = from(w in Widget, where: w.account_id == ^id)
                |> Repo.all()

    Enum.each(widgets, fn widget -> send_widget(widget, to_id) end)
  end

  def send_widget(widget, to_id) do
    RequestProducer.publish(encode_widget_request(widget.id, to_id))
  end

  defp encode_widget_request(id, to_id) do
    Poison.encode!(%{widget_request:
      %{id: id, to_id: to_id}
    })
  end
end
