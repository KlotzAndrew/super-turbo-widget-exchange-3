defmodule WebApi.WidgetSender do
  import Ecto.Query
  alias WebApi.{Widget, Repo}

  def transfer_all(id, to_id) do
    widgets = from(w in Widget, where: w.account_id == ^id)
                |> Repo.all()

    Enum.each(widgets, fn widget -> send_widget(widget, to_id) end)
  end

  defp send_widget(widget, to_id) do
    HTTPoison.post(
      "http://web_api:4000/widgets/receive",
      Poison.encode!(%{token: widget.token, to_id: to_id}),
      [{"Content-Type", "application/json"}]
    )
  end
end
