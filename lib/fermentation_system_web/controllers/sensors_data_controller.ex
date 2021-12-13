defmodule FermentationSystemWeb.SensorsDataController do
  use FermentationSystemWeb, :controller

  alias Database.{SensorsData, Sensors}
  alias Core.Alerts

  action_fallback FermentationSystemWeb.FallbackController

  @spec index(conn :: Plug.Conn.t(), map()) :: map()
  def index(conn, %{"type" => type, "fermentation_process_id" => fermentation_process_id, "initial_date" => initial_date,
    "final_date" => final_date}) do
    {:ok, start_date} = Date.from_iso8601(initial_date)
    {:ok, end_date} = Date.from_iso8601(final_date)

    {:ok, data} = SensorsData.get_specific_data_in_rank_time(type, fermentation_process_id, start_date, end_date)

    render(conn, "index.json", sensors_data: data)
  end

  @spec set(conn :: Plug.Conn.t(), params :: map()) :: map()
  def set(conn, %{"value" => value, "sensor_mac" => sensor_mac} = params) do
    {float_value, _rest} = Float.parse(value)

    with {:ok, datum} <- SensorsData.insert_datum(params),
         {:ok, sensor} <- Sensors.get_sensor_by_mac(sensor_mac),
         {:ok, _response} <- Alerts.send_alert(float_value, sensor) do
      render(conn, "insert.json", datum_id: datum.id)
    end
  end
end