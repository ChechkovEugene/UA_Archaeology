defmodule UaArchaeology.Repo.Migrations.AddLayerThickness do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :layer_thickness, :decimal
    end
  end
end
