defmodule WebApi.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string, null: false

      timestamps()
    end

  end
end
