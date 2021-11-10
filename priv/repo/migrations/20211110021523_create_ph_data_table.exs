defmodule FermentationSystem.Repo.Migrations.CreatePhDataTable do
  use Ecto.Migration

  def change do
    create table(:ph_data, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :float
      add :mac_sensor, :string
      add :fermentation_process_id, references(:fermentation_processes, column: :id, type: :uuid, on_delete: :restrict)

      timestamps()
    end
  end
end
