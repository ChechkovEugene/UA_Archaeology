defmodule UaArchaeology.Repo.Migrations.AddUserIdToAuthors do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :user_id, references(:users)
    end
    create index(:authors, [:user_id])
  end
end
