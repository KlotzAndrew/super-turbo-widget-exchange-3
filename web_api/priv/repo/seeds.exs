# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WebApi.Repo.insert!(%WebApi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WebApi.{Account, Widget, Repo}

if Repo.aggregate(Account, :count, :id) == 0 do
  Repo.transaction fn ->
    account_1 = Repo.insert! %Account{name: "account_1"}

    Repo.insert! %Account{name: "account_2"}

    Enum.map 1..10, fn x ->
      Repo.insert %Widget{token: x, account_id: account_1.id}
    end
  end
end
