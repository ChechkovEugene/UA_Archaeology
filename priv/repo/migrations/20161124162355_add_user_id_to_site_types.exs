defmodule UaArchaeology.Repo.Migrations.AddUserIdToSiteTypes do
  use Ecto.Migration

  def change do
    alter table(:site_types) do
      add :user_id, references(:users)
    end
    create index(:site_types, [:user_id])
  end
end
