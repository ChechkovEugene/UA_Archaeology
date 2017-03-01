defmodule UaArchaeology.FindSiteType do
  use UaArchaeology.Web, :model

  @primary_key {:id, :id, autogenerate: false}

  schema "finds_site_types" do
    belongs_to :find, UaArchaeology.Find
    belongs_to :site_type, UaArchaeology.SiteType, foreign_key: :parameter_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:find_id, :parameter_id])
    |> validate_required([:find_id, :parameter_id])
    |> unique_constraint(:find_id, :parameter_id)
  end
end
