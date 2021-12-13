defmodule Database.Alerts do
  @moduledoc """
    This module is responsible for doing the CRUD operations of alerts.
  """
  import Ecto.Query, warn: false

  alias FermentationSystem.Repo
  alias Database.{Alert, FermentationProcess}

  @spec get_alerts_by_fermentation_process(fermentation_process_id :: term()) :: {:ok, list(Alert.t())}
  def get_alerts_by_fermentation_process(fermentation_process_id) do
    %{alerts: alerts} = FermentationProcess
                        |> Repo.get_by(id: fermentation_process_id)
                        |> Repo.preload(:alerts)

    {:ok, alerts}
  end

  @spec insert_alert(changes :: map()) :: {:ok, map()} | {:error, map()}
  def insert_alert(changes) do
    %Alert{}
    |> Alert.changeset(changes)
    |> Repo.insert()
  end

  @spec update_alert(id :: term(), changes :: map()) :: {:ok, Alert.t()} | {:error, map()}
  def update_alert(id, changes) do
    Alert
    |> Repo.get(id)
    |> persist_update(changes)
  end

  @spec get_alert_by_id(id :: binary()) :: {:ok, Alert.t()}
  def get_alert_by_id(id) do
    alert = Repo.get_by(Alert, id: id)

    {:ok, alert}
  end

  @spec delete_alert(id :: binary()) :: {:ok, Alert.t()} | {:error, term()}
  def delete_alert(id) do
    id
    |> get_alert_by_id()
    |> delete()
  end

  @spec delete({:ok, alert :: Alert.t() | nil}) :: {:ok, Alert.t()} | {:error, term()}
  defp delete({:ok, nil}), do: {:error, :not_found}
  defp delete({:ok, alert}), do: Repo.delete(alert)

  @spec persist_update(alert :: Alert.t(), changes :: map()) :: {:ok, Alert.t()} | {:error, term()}
  defp persist_update(nil, _changes), do: {:error, :not_found}

  defp persist_update(alert, changes) do
    alert
    |> Alert.changeset(changes)
    |> Repo.update()
  end
end