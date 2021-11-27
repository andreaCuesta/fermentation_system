defmodule FermentationSystemWeb.SensorsDataView do
  use FermentationSystemWeb, :view

  alias FermentationSystemWeb.SensorsDataView

  def render("index.json", %{sensors_data: sensors_data}), do:
  %{data: render_many(sensors_data, SensorsDataView, "sensor_data.json")}

  def render("sensor_data.json", %{sensors_data: data}) do
    %{
      id: data.id,
      mac_sensor: data.sensor_mac,
      value: data.value,
      inserted_at: data.inserted_at,
    }
  end
end