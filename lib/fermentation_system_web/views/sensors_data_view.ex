defmodule FermentationSystemWeb.SensorsDataView do
  use FermentationSystemWeb, :view

  alias FermentationSystemWeb.SensorsDataView

  @spec render(String.t(), map()) :: map()
  def render("index.json", %{sensors_data: sensors_data}), do:
  %{status: :success, data: render_many(sensors_data, SensorsDataView, "sensor_data.json")}

  def render("sensor_data.json", %{sensors_data: data}) do
    %{
      id: data.id,
      mac_sensor: data.sensor_mac,
      value: data.value,
      inserted_at: data.inserted_at
    }
  end

  def render("insert.json", %{datum_id: datum_id}), do:
    %{
    status: :success,
    new_datum_id: datum_id
  }
end