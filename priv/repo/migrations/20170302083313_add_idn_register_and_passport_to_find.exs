defmodule UaArchaeology.Repo.Migrations.AddIdnRegisterAndPassportToFind do
  use Ecto.Migration

  def change do
    alter table(:finds) do
      add :idn, :string
      add :register, :string
      add :passport, :string
      add :description, :text

    end
  end
end
