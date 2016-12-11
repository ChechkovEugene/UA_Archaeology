defmodule UaArchaeology.Repo.Migrations.CreatePublication do
  use Ecto.Migration

  def change do
    create table(:publication) do
      add :name, :string

      timestamps()
    end

  end
end
