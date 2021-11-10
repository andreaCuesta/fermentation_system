defmodule FermentationSystem.PhData do
  @moduledoc """
  Module that contains schema for pH Data.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias FermentationSystem.FermentationProcess

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "ph_data" do
    field :value, :float
    field :mac_sensor, :string
    belongs_to(:fermentation_process, FermentationProcess, type: :binary_id)

    timestamps()
  end

  @fields ~w(value mac_sensor fermentation_process_id)
  @spec changeset(ph_data :: PhData.t(), changes :: map()) :: Changeset.t()
  def changeset(ph_data, changes) do
    ph_data
    |> cast(changes, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:fermentation_process_id)
  end
end