defmodule UaArchaeology.Repo.Migrations.AddManyToMany do
  use Ecto.Migration

  def change do
    create table(:finds_conditions) do
      add :find_id, references(:finds, on_delete: :delete_all)
      add :condition_id, references(:conditions, on_delete: :delete_all)
    end

    create table(:finds_research_levels) do
      add :find_id, references(:finds, on_delete: :delete_all)
      add :research_level_id, references(:research_levels, on_delete: :delete_all)
    end

    create index(:finds_conditions, [:find_id])
    create index(:finds_conditions, [:condition_id])
    create unique_index(:finds_conditions, [:find_id, :condition_id])

    create index(:finds_research_levels, [:find_id])
    create index(:finds_research_levels, [:research_level_id])
    create unique_index(:finds_research_levels, [:find_id, :research_level_id])
  end
end
