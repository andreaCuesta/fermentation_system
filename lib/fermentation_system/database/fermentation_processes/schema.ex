defmodule Database.FermentationProcess do
  @moduledoc """
  Module that contains schema for a fermentation process.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Database.Sensor
  alias Database.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "fermentation_processes" do
    field :status, Ecto.Enum, values: [:in_progress, :completed]
    has_many(:sensor, Sensor, on_delete: :delete_all)
    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  @fields ~w(status user_id)a
  @spec changeset(fermentation_process :: FermentationProcess.t(), changes :: map()) :: Changeset.t()
  def changeset(fermentation_process, changes) do
    fermentation_process
    |> cast(changes, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:user_id)
  end
end