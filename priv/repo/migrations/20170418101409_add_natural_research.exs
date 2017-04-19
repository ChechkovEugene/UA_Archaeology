defmodule UaArchaeology.Repo.Migrations.AddNaturalResearch do
  use Ecto.Migration

  def change do
    create table(:natural_researches) do
      add :name, :string
      add :user_id, references(:users)

      timestamps()
    end
    create index(:natural_researches, [:user_id])

    create table(:finds_natural_researches) do
      add :find_id, references(:finds, on_delete: :delete_all)
      add :parameter_id, references(:natural_researches, on_delete: :delete_all)
    end

    create index(:finds_natural_researches, [:find_id])
    create index(:finds_natural_researches, [:parameter_id])
    create unique_index(:finds_natural_researches, [:find_id, :parameter_id])
  end
end
