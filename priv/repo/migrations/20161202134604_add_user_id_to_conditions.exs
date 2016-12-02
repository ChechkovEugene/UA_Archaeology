defmodule UaArchaeology.Repo.Migrations.AddUserIdToConditions do
  use Ecto.Migration

  def change do
    alter table(:conditions) do
      add :user_id, references(:users)
    end
    create index(:conditions, [:user_id])
  end
end
