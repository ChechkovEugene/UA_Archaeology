defmodule UaArchaeology.Repo.Migrations.CreateSiteType do
  use Ecto.Migration

  def change do
    create table(:site_types) do
      add :name, :string

      timestamps()
    end

  end
end
