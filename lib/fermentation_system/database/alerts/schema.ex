defmodule Database.Alert do
  @moduledoc """
  Module that contains schema for alert.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Database.FermentationProcess

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "alerts" do
    field :type, Ecto.Enum, values: [:ph, :temperature]
    field :value, :float
    belongs_to(:fermentation_process, FermentationProcess, type: :binary_id)

    timestamps()
  end

  @fields ~w(type value fermentation_process_id)a
  @spec changeset(alert :: Alert.t(), changes :: map()) :: Changeset.t()
  def changeset(alert, changes) do
    alert
    |> cast(changes, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:fermentation_process_id)
  end
end