defmodule UaArchaeology.Repo.Migrations.ChangeLatLngOnFind do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      remove :lat
      remove :lng
      add :lat, :decimal
      add :lng, :decimal
    end
  end
end
