defmodule WebApi.Repo.Migrations.CreateWidget do
  use Ecto.Migration

  def change do
    create table(:widgets) do
      add :token, :integer, null: false
      add :account_id, :integer, null: false

      timestamps()
    end

  end
end
