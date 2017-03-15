defmodule UaArchaeology.Repo.Migrations.AddFindWidthHeight do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :width, :decimal
      add :height, :decimal
    end
  end
end
