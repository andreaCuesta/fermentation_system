defmodule FermentationSystem.FermentationProcess do
  @moduledoc """
  Module that contains schema for fermentation process.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias FermentationSystem.PhData
  alias FermentationSystem.User
  alias FermentationSystem.TemperatureData

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "fermentation_process" do
    field :status, :string
    has_many(:ph_data, PhData, on_delete: :delete_all)
    has_many(:temperature_data, TemperatureData, on_delete: :delete_all)
    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  @fields ~w(status user_id)
  @spec changeset(fermentation_process :: FermentationProcess.t(), changes :: map()) :: Changeset.t()
  def changeset(fermentation_process, changes) do
    fermentation_process
    |> cast(changes, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:user_id)
  end
end