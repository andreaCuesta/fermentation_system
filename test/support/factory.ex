defmodule Database.Factory do
  @moduledoc """
    This module is responsible of managing factories.
  """
  use ExMachina.Ecto, repo: FermentationSystem.Repo

  use Database.{
    UserFactory,
    FermentationProcessFactory,
    SensorFactory,
    SensorDataFactory
  }
end