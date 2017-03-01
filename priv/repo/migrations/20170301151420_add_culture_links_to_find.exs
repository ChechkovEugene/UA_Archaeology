defmodule UaArchaeology.Repo.Migrations.AddCultureLinksToFind do
  use Ecto.Migration

  def change do
    create table(:finds_cultures) do
      add :find_id, references(:finds, on_delete: :delete_all)
      add :parameter_id, references(:cultures, on_delete: :delete_all)
    end

    create index(:finds_cultures, [:find_id])
    create index(:finds_cultures, [:parameter_id])
    create unique_index(:finds_cultures, [:find_id, :parameter_id])
  end
end
