defmodule UaArchaeology.Repo.Migrations.AddAuthorsLinksToFind do
  use Ecto.Migration

  def change do
    create table(:finds_authors) do
      add :find_id, references(:finds, on_delete: :delete_all)
      add :parameter_id, references(:authors, on_delete: :delete_all)
    end

    create index(:finds_authors, [:find_id])
    create index(:finds_authors, [:parameter_id])
    create unique_index(:finds_authors, [:find_id, :parameter_id])
  end
end
