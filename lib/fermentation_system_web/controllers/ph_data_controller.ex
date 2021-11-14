defmodule FermentationSystemWeb.PhDataController do
  use FermentationSystemWeb, :controller

  alias Database.PhData

  def index(conn, %{"initial_date" => initial_date, "final_date" => final_date}) do
    {:ok, start_date} = Date.from_iso8601(initial_date)
    {:ok, end_date} = Date.from_iso8601(final_date)

    {:ok, ph_data} = PhData.get_ph_data_in_rank_time(start_date, end_date)

    render(conn, "index.json", ph_data: ph_data)
  end

end