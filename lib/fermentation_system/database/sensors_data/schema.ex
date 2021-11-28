defmodule Database.SensorData do
  @moduledoc """
  Module that contains schema for sensor data.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Database.Sensor

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "sensors_data" do
    field :value, :float
    belongs_to(:sensor, Sensor, type: :string, foreign_key: :sensor_mac, references: :mac)

    timestamps()
  end

  @fields ~w(value sensor_mac)a
  @spec changeset(sensor_data :: SensorData.t(), changes :: map()) :: Changeset.t()
  def changeset(sensor_data, changes) do
    sensor_data
    |> cast(changes, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:sensor_mac)
  end
end