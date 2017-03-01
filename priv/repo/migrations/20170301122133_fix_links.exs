defmodule UaArchaeology.Repo.Migrations.FixLinks do
  use Ecto.Migration

  def change do
    alter table(:finds_research_levels) do
      remove :parameter_id
      add :parameter_id, references(:research_levels, on_delete: :delete_all)
    end
  end
end
