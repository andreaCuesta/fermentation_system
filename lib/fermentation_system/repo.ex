defmodule FermentationSystem.Repo do
  use Ecto.Repo,
    otp_app: :fermentation_system,
    adapter: Ecto.Adapters.Postgres
end
