defmodule UaArchaeology.Repo.Migrations.CreateObjectType do
  use Ecto.Migration

  def change do
    create table(:object_types) do
      add :name, :string

      timestamps()
    end

  end
end
