defmodule FermentationSystemWeb.AlertsController do
  use FermentationSystemWeb, :controller

  alias Database.Alerts

  action_fallback FermentationSystemWeb.FallbackController

  @spec index(conn :: Plug.Conn.t(), map()) :: map()
  def index(conn, %{"fermentation_process_id" => fermentation_process_id}) do
    {:ok, alerts} = Alerts.get_alerts_by_fermentation_process(fermentation_process_id)

    render(conn, "index.json", alerts: alerts)
  end

  @spec create(conn :: Plug.Conn.t(), map()) :: map()
  def create(conn, %{"fermentation_process_id" => fermentation_process_id, "type" => type, "value" => value} = params) do
    with {:ok, alert} <- Alerts.insert_alert(params) do
      render(conn, "insert.json", alert_id: alert.id)
    end
  end

  @spec update(conn :: Plug.Conn.t(), map()) :: map()
  def update(conn, %{"id" => alert_id, "changes" => changes}) do
    with {:ok, updated_alert} <- Alerts.update_alert(alert_id, changes) do
      render(conn, "update_delete.json", alert: updated_alert)
    end
  end

  @spec delete(conn :: Plug.Conn.t(), map()) :: map()
  def delete(conn, %{"id" => alert_id}) do
    with {:ok, deleted_alert} <- Alerts.delete_alert(alert_id) do
      render(conn, "update_delete.json", alert: deleted_alert)
    end
  end
end