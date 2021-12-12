defmodule FermentationSystem.Notifications.Email do
  import Bamboo.Email

  @sender_email "fermentation@mg.jezacloud.co"
  @dashboard_url "https://fermentation-dashboard.herokuapp.com"

  @spec ph_alert_email(user_email :: String.t(), target_value :: float()) :: Email.t()
  def ph_alert_email(user_email, target_value) do
    new_email(
      to: user_email,
      from: @sender_email,
      subject: "Alerta de pH",
      html_body: "<h3>¡Alerta de pH!</h3>
                  <p>El proceso de fermentación ha alcanzado el valor <b>#{target_value}</b> en el pH,
                  se recomienda revisar la curva de pH.</p>
                  <p><a href='#{@dashboard_url}'>Dashboard - Proceso de fermentación</a>",
    )
  end

  @spec temperature_alert_email(user_email :: String.t(), target_value :: float(), type :: atom()) :: Email.t()
  def temperature_alert_email(user_email, target_value, type) do
    text_body = temperature_alert_text_body(type, target_value) <> "<p><a href='#{@dashboard_url}'>Dashboard - Proceso de fermentación</a></p>"

    new_email(
      to: user_email,
      from: @sender_email,
      subject: "Alerta de temperatura",
      html_body: "<h3>¡Alerta de temperatura!</h3>" <> text_body
    )
  end

  @spec temperature_alert_text_body(atom(), target_value :: float()) :: String.t()
  defp temperature_alert_text_body(:higher, target_value), do:
    "<p>El proceso de fermentación ha alcanzado una temperatura superior a <b>#{target_value} oC</b>, se recomienda revisar el equipo.</p>"

  defp temperature_alert_text_body(:lower, target_value), do:
    "<p>El proceso de fermentación tiene una temperatura por debajo de <b>#{target_value} oC</b>, se recomienda revisar el equipo.</p>"
end