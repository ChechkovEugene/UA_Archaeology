defmodule UaArchaeology.Repo.Migrations.RemoveFindsLinks do
  use Ecto.Migration

  def change do

    drop_if_exists index(:finds, [:condition_id])
    drop_if_exists index(:finds, [:research_level_id])
    alter table(:finds) do
      remove :condition_id
      remove :research_level_id
    end
  end
end
