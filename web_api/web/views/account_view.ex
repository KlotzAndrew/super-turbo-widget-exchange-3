defmodule WebApi.AccountView do
  use WebApi.Web, :view

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, WebApi.AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, WebApi.AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id,
      name: account.name}
  end
end
