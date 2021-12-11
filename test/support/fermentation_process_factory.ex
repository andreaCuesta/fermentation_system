defmodule Database.FermentationProcessFactory do
  @moduledoc """
    Allow the creation of fermentation processes while testing.
  """
  defmacro __using__(_opts) do
    quote do
      def fermentation_process_factory do
        %Database.FermentationProcess{
          status: :in_progress,
          user: build(:user)
        }
      end
    end
  end
end