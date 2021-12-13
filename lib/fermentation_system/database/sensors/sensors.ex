defmodule Database.Sensors do
  @moduledoc """
    This module is responsible for doing some sensors queries.
  """
  import Ecto.Query, warn: false

  alias FermentationSystem.Repo
  alias Database.Sensor

  @spec get_sensor_by_mac(mac :: String.t()) :: {:ok, Sensor.t()}
  def get_sensor_by_mac(mac) do
    sensor = Repo.get_by(Sensor, mac: mac)

    {:ok, sensor}
  end
end