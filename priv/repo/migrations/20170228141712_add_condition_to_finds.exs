defmodule UaArchaeology.Repo.Migrations.AddConditionToFinds do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :condition_id, references(:conditions)
    end
    create index(:finds, [:condition_id])
  end
end
