defmodule UaArchaeology.Repo.Migrations.RemoveManyToMany do
  use Ecto.Migration

  def change do
    drop_if_exists index(:finds_conditions, [:find_id])
    drop_if_exists index(:finds_conditions, [:condition_id])
    drop_if_exists index(:finds_conditions, [:find_id, :condition_id])

    drop_if_exists index(:finds_research_levels, [:find_id])
    drop_if_exists index(:finds_research_levels, [:research_level_id])
    drop_if_exists index(:finds_research_levels, [:find_id, :research_level_id])

    alter table(:finds_conditions) do
      remove :condition_id
      add :parameter_id, references(:conditions, on_delete: :delete_all)
    end

    alter table(:finds_research_levels) do
      remove :research_level_id
      add :parameter_id, references(:conditions, on_delete: :delete_all)
    end
  end
end
