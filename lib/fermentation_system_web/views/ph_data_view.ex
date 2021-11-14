defmodule FermentationSystemWeb.PhDataView do
  use FermentationSystemWeb, :view

  alias FermentationSystemWeb.PhDataView

  def render("index.json", %{ph_data: ph_data}), do:
  %{data: render_many(ph_data, PhDataView, "ph_datum.json")}

  def render("ph_datum.json", %{ph_data: ph_data}) do
    %{
      id: ph_data.id,
      fermentation_process_id: ph_data.fermentation_process_id,
      mac_sensor: ph_data.mac_sensor,
      value: ph_data.value,
      inserted_at: ph_data.inserted_at,
    }
  end
end