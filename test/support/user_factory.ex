defmodule Database.UserFactory do
  @moduledoc """
    Allow the creation of users while testing.
  """
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Database.User{
          email: sequence(:email, &"a1s2d33d4f4#{&1}")
        }
      end
    end
  end
end