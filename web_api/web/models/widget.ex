defmodule WebApi.Widget do
  use WebApi.Web, :model

  schema "widgets" do
    field :token, :integer
    field :account_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :account_id])
    |> validate_required([:token, :account_id])
  end
end
