defmodule WebApi.WidgetView do
  use WebApi.Web, :view

  def render("index.json", %{widgets: widgets}) do
    %{data: render_many(widgets, WebApi.WidgetView, "widget.json")}
  end

  def render("show.json", %{widget: widget}) do
    %{data: render_one(widget, WebApi.WidgetView, "widget.json")}
  end

  def render("widget.json", %{widget: widget}) do
    %{id: widget.id,
      token: widget.token,
      account_id: widget.account_id}
  end
end
