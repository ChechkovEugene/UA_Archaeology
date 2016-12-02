defmodule UaArchaeology.Repo.Migrations.CreateCondition do
  use Ecto.Migration

  def change do
    create table(:conditions) do
      add :name, :string

      timestamps()
    end

  end
end
