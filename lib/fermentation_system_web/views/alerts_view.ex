defmodule FermentationSystemWeb.AlertsView do
  use FermentationSystemWeb, :view

  alias FermentationSystemWeb.AlertsView

  @spec render(String.t(), map()) :: map()
  def render("index.json", %{alerts: alerts}), do:
  %{status: :success, data: render_many(alerts, AlertsView, "alert.json")}

  def render("alert.json", %{alerts: data}) do
    %{
      id: data.id,
      type: data.type,
      value: data.value,
      inserted_at: data.inserted_at,
      updated_at: data.updated_at
    }
  end

  def render("insert.json", %{alert_id: alert_id}), do:
  %{
    status: :success,
    new_alert_id: alert_id
  }

  def render("update_delete.json", %{alert: alert}), do:
  %{
    status: :success,
    alert: render("alert.json", %{alerts: alert})
  }
end