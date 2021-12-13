defmodule Core.Alerts do
  @moduledoc """
    This module is responsible of alerts operations.
  """

  alias Notifications.Alerts.Controller
  alias Database.{Alerts, Users}

  @spec send_alert(sensor_value :: float(), sensor :: map()) :: {:ok, Email.t()} | {:ok, atom()} | {:error, Bamboo.ApiError.t()}
  def send_alert(sensor_value, %{fermentation_process_id: fermentation_process_id, type: :ph} = _sensor) do
    {:ok, alerts} = Alerts.get_alerts_by_fermentation_process(fermentation_process_id)

    alerts
    |> Enum.find(fn %{type: type, value: alert_value} -> type == :ph and sensor_value <= alert_value end)
    |> send_ph_alert(fermentation_process_id)
  end

  def send_alert(sensor_value, %{fermentation_process_id: fermentation_process_id, type: :temperature} = _sensor) do
    {:ok, alerts} = Alerts.get_alerts_by_fermentation_process(fermentation_process_id)

    alerts
    |> Enum.find(fn %{type: type} -> type == :temperature end)
    |> send_temperature_alert(sensor_value, fermentation_process_id)
  end

  @spec send_ph_alert(alert :: map(), fermentation_process_id :: binary()) :: {:ok, Email.t()} | {:ok, atom()} |
          {:error, Bamboo.ApiError.t()}
  defp send_ph_alert(%{value: target_value} = _alert, fermentation_process_id) do
    {:ok, %{email: email}} = Users.get_user_owner_of_fermentation_process(fermentation_process_id)

    Controller.send_ph_alert_email(email, target_value)
  end

  defp send_ph_alert(nil, _fermentation_process_id), do: {:ok, :no_alert_sent}

  defp send_temperature_alert(%{value: target_value} = _alert, sensor_value, fermentation_process_id) when
         trunc(sensor_value) - trunc(target_value) == 2 do
    {:ok, %{email: email}} = Users.get_user_owner_of_fermentation_process(fermentation_process_id)

    Controller.send_temperature_alert_email(email, target_value, :higher)
  end

  @spec send_temperature_alert(alert :: map(), sensor_value :: float(), fermentation_process_id :: binary()) ::
          {:ok, Email.t()} | {:ok, atom()} | {:error, Bamboo.ApiError.t()}
  defp send_temperature_alert(%{value: target_value} = _alert, sensor_value, fermentation_process_id) when
         trunc(target_value) - trunc(sensor_value) == 2 do
    {:ok, %{email: email}} = Users.get_user_owner_of_fermentation_process(fermentation_process_id)

    Controller.send_temperature_alert_email(email, target_value, :lower)
  end

  defp send_temperature_alert(_alert, _sensor_value, _fermentation_process_id), do: {:ok, :no_alert_sent}
end