defmodule Database.SensorFactory do
  @moduledoc """
    Allow the creation of sensors while testing.
  """
  defmacro __using__(_opts) do
    quote do
      def sensor_factory do
        %Database.Sensor{
          mac: sequence(:sensor_mac,  &"ABCDE#{&1}"),
          type: :ph,
          fermentation_process: build(:fermentation_process)
        }
      end
    end
  end
end