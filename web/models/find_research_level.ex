defmodule UaArchaeology.FindResearchLevel do
  use UaArchaeology.Web, :model

  @primary_key {:id, :id, autogenerate: false}

  schema "finds_research_levels" do
    belongs_to :find, UaArchaeology.Find
    belongs_to :research_level, UaArchaeology.ResearchLevel,
      foreign_key: :parameter_id
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:find_id, :research_level_id])
    |> validate_required([:find_id, :research_level_id])
    |> unique_constraint(:condition_id, :research_level_id)
  end
end
