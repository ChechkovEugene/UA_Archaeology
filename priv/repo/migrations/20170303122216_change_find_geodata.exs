defmodule UaArchaeology.Repo.Migrations.ChangeFindGeodata do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      remove :coords1
      remove :coords2
      remove :coords3
      remove :coords4
      add :coord1N,     :string
      add :coord2N,     :string
      add :coord3N,     :string
      add :coord4N,     :string
      add :coord1E,     :string
      add :coord2E,     :string
      add :coord3E,     :string
      add :coord4E,     :string
    end
  end
end
