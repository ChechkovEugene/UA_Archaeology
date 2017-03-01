defmodule UaArchaeology.Repo.Migrations.AddSiteTypeLinksToFind do
  use Ecto.Migration

  def change do
    create table(:finds_site_types) do
      add :find_id, references(:finds, on_delete: :delete_all)
      add :parameter_id, references(:site_types, on_delete: :delete_all)
    end

    create index(:finds_site_types, [:find_id])
    create index(:finds_site_types, [:parameter_id])
    create unique_index(:finds_site_types, [:find_id, :parameter_id])
  end
end
