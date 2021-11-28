defmodule Database.User do
  @moduledoc """
  Module that contains schema for user.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Database.FermentationProcess

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    has_many(:fermentation_process, FermentationProcess, on_delete: :delete_all)

    timestamps()
  end

  @spec changeset(user :: User.t(), changes :: map()) :: Changeset.t()
  def changeset(user, changes) do
    user
    |> cast(changes, [:email])
    |> unique_constraint(:email)
  end
end