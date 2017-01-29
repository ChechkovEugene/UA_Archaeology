defmodule UaArchaeology.Repo.Migrations.CreateFind do
  use Ecto.Migration

  def change do
    create table(:finds) do
      add :title, :string
      add :topo, :string

      timestamps()
    end

  end
end
