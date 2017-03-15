defmodule UaArchaeology.Repo.Migrations.AddStoragePlace do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :storage_place, :string
    end
  end
end
