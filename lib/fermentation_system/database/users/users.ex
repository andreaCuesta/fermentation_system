defmodule Database.Users do
  @moduledoc """
    This module is responsible for doing some users queries.
  """
  import Ecto.Query, warn: false

  alias FermentationSystem.Repo
  alias Database.{FermentationProcess, User}

  @spec get_user_owner_of_fermentation_process(mac :: String.t()) :: {:ok, Sensor.t()}
  def get_user_owner_of_fermentation_process(fermentation_process_id) do
    user = from(user in User,
               join: fermentation_process in FermentationProcess,
               on: fermentation_process.user_id == user.id,
               where: fermentation_process.id == ^fermentation_process_id
              )
             |> Repo.one()

    {:ok, user}
  end
end