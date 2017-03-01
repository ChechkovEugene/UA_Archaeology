defmodule UaArchaeology.Repo.Migrations.AddIndexesOnMany do
  use Ecto.Migration

  def change do
    create index(:finds_conditions, [:find_id])
    create index(:finds_conditions, [:parameter_id])
    create unique_index(:finds_conditions, [:find_id, :parameter_id])

    create index(:finds_research_levels, [:find_id])
    create index(:finds_research_levels, [:parameter_id])
    create unique_index(:finds_research_levels, [:find_id, :parameter_id])
  end
end
