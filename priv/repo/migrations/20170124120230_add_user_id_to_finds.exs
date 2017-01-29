defmodule UaArchaeology.Repo.Migrations.AddUserIdToFinds do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :user_id, references(:users)
    end
    create index(:finds, [:user_id])
  end
end
