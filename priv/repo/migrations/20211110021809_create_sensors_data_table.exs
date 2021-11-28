defmodule FermentationSystem.Repo.Migrations.CreateSensorsDataTable do
  use Ecto.Migration

  def change do
    create table(:sensors_data, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :float
      add :sensor_mac, references(:sensors, column: :mac, type: :string, on_delete: :restrict)

      timestamps()
    end
  end
end
