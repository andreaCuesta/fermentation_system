defmodule FermentationSystem.Repo.Migrations.CreateFermentationProcessTable do
  use Ecto.Migration

  def change do
    create table(:fermentation_processes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :string
      add :user_id, references(:users, column: :id, type: :uuid, on_delete: :restrict)

      timestamps()
    end
  end
end
