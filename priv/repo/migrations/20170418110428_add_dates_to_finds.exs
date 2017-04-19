defmodule UaArchaeology.Repo.Migrations.AddDatesToFinds do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :start_date, :string
      add :end_date, :string

    end
  end
end
