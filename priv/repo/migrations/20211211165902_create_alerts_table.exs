defmodule FermentationSystem.Repo.Migrations.CreateAlertsTable do
  use Ecto.Migration

  def change do
    create table(:alerts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :value, :float
      add :fermentation_process_id, references(:fermentation_processes, column: :id, type: :uuid, on_delete: :restrict)

      timestamps()
    end
  end
end
