defmodule Notifications.Alerts.Controller do

  alias FermentationSystem.Notifications.Email
  alias FermentationSystem.Notifications.Mailer

  @spec send_ph_alert_email(user_email :: String.t(), target_value :: float()) :: {:ok, Email.t()} | {:error, Bamboo.ApiError.t()}
  def send_ph_alert_email(user_email, target_value) do
    user_email
    |> Email.ph_alert_email(target_value)
    |> Mailer.deliver_now()
  end

  @spec send_temperature_alert_email(user_email :: String.t(), target_value :: float(), type :: atom()) ::
          {:ok, Email.t()} | {:error, Bamboo.ApiError.t()}
  def send_temperature_alert_email(user_email, target_value, type) do
    user_email
    |> Email.temperature_alert_email(target_value, type)
    |> Mailer.deliver_now()
  end
end