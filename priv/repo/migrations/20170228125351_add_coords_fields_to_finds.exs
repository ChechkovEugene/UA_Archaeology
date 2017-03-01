defmodule UaArchaeology.Repo.Migrations.AddCoordsFieldsToFinds do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :lat, :string
      add :lng, :string
    end
  end
end
