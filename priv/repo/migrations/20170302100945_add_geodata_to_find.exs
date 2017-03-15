defmodule UaArchaeology.Repo.Migrations.AddGeodataToFind do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :coords1,     :geometry
      add :coords2,     :geometry
      add :coords3,     :geometry
      add :coords4,     :geometry
      add :area,        :decimal
    end
  end
end
