defmodule UaArchaeology.Repo.Migrations.AddArchivalStorage do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :archival_storage, :string
    end
  end
end
