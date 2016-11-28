defmodule UaArchaeology.Repo.Migrations.CreateResearchLevel do
  use Ecto.Migration

  def change do
    create table(:research_levels) do
      add :name, :string

      timestamps()
    end

  end
end
