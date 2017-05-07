defmodule WebApi.WidgetFinder do
  import Ecto.Query
  alias WebApi.{Widget, Repo}

  def find_for_account(account_id) do
    from(w in Widget, where: w.account_id == ^account_id)
      |> Repo.all()
  end
end
