defmodule FermentationSystemWeb.SensorsDataController do
  use FermentationSystemWeb, :controller

  alias Database.SensorsData

  def index(conn, %{"type" => type, "fermentation_process_id" => fermentation_process_id, "initial_date" => initial_date,
    "final_date" => final_date}) do
    {:ok, start_date} = Date.from_iso8601(initial_date)
    {:ok, end_date} = Date.from_iso8601(final_date)

    {:ok, data} = SensorsData.get_specific_data_in_rank_time(type, fermentation_process_id, start_date, end_date)

    render(conn, "index.json", sensors_data: data)
  end

  def set(conn, %{value: value, mac_sensor: mac_sensor}) do

  end

end