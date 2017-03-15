defmodule UaArchaeology.Repo.Migrations.AddAnotherNames do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :another_name, :string
    end
  end
end
