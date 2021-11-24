defmodule Database.Sensor do
  @moduledoc """
  Module that contains schema for sensor.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Database.FermentationProcess
  alias Database.SensorData

  @primary_key {:mac, :string, autogenerate: false}
  @foreign_key_type Ecto.UUID
  schema "sensors" do
    field :type, Ecto.Enum, values: [:ph, :temperature]
    has_many(:sensor_data, SensorData, on_delete: :delete_all)
    belongs_to(:fermentation_process, FermentationProcess, type: :binary_id)

    timestamps()
  end

  @fields ~w(mac type fermentation_process)a
  @spec changeset(sensor :: Sensor.t(), changes :: map()) :: Changeset.t()
  def changeset(sensor, changes) do
    sensor
    |> cast(changes, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:fermentation_process)
  end
end