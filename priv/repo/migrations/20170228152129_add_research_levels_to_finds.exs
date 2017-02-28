defmodule UaArchaeology.Repo.Migrations.AddResearchLevelsToFinds do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :research_level_id, references(:research_levels)
    end
    create index(:finds, [:research_level_id])
  end
end
