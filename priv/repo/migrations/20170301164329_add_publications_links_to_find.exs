defmodule UaArchaeology.Repo.Migrations.AddPublicationsLinksToFind do
  use Ecto.Migration

  def change do
    create table(:finds_publications) do
      add :find_id, references(:finds, on_delete: :delete_all)
      add :parameter_id, references(:publications, on_delete: :delete_all)
    end

    create index(:finds_publications, [:find_id])
    create index(:finds_publications, [:parameter_id])
    create unique_index(:finds_publications, [:find_id, :parameter_id])
  end
end
