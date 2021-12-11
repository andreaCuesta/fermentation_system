defmodule Database.SensorDataFactory do
  @moduledoc """
    Allow the creation of sensors data while testing.
  """
  defmacro __using__(_opts) do
    quote do
      def sensor_data_factory do
        %{mac: sensor_mac} = insert(:sensor)

        %Database.SensorData{
          value: 2.5,
          sensor_mac: sensor_mac
        }
      end
    end
  end
end