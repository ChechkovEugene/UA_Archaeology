defmodule UaArchaeology.Repo.Migrations.CreateCulture do
  use Ecto.Migration

  def change do
    create table(:cultures) do
      add :name, :string

      timestamps()
    end

  end
end
