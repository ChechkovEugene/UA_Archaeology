defmodule UaArchaeology.Repo.Migrations.AddUserIdToCultures do
  use Ecto.Migration

  def change do
    alter table(:cultures) do
      add :user_id, references(:users)
    end
    create index(:cultures, [:user_id])
  end
end
