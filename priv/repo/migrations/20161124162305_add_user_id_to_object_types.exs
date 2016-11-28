defmodule UaArchaeology.Repo.Migrations.AddUserIdToObjectTypes do
  use Ecto.Migration

  def change do
    alter table(:object_types) do
      add :user_id, references(:users)
    end
    create index(:object_types, [:user_id])
  end
end
