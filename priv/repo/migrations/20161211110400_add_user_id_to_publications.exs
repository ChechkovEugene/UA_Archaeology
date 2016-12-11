defmodule UaArchaeology.Repo.Migrations.AddUserIdToPublications do
  use Ecto.Migration

  def change do
    rename table(:publication), to: table(:publications)

    alter table(:publications) do
      add :user_id, references(:users)
    end
    create index(:publications, [:user_id])
  end
end
