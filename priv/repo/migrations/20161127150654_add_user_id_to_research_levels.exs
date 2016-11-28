defmodule UaArchaeology.Repo.Migrations.AddUserIdToResearchLevels do
  use Ecto.Migration

  def change do
    alter table(:research_levels) do
      add :user_id, references(:users)
    end
    create index(:research_levels, [:user_id])
  end
end
