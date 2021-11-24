defmodule FermentationSystem.Repo.Migrations.CreateSensorsTable do
  use Ecto.Migration

  def change do
    create table(:sensors, primary_key: false) do
      add :mac, :string, primary_key: true
      add :type, :string
      add :fermentation_process_id, references(:fermentation_processes, column: :id, type: :uuid, on_delete: :restrict)

      timestamps()
    end
  end
end
