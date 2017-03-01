defmodule UaArchaeology.Find do
  use UaArchaeology.Web, :model

  schema "finds" do
    field :title, :string
    field :topo, :string
    belongs_to :user, UaArchaeology.User
    many_to_many :conditions, UaArchaeology.Condition,
      join_through: UaArchaeology.FindCondition,
      join_keys: [find_id: :id, parameter_id: :id], on_delete: :delete_all
    many_to_many :research_levels, UaArchaeology.ResearchLevel,
      join_through: UaArchaeology.FindResearchLevel,
      join_keys: [find_id: :id, parameter_id: :id], on_delete: :delete_all
    many_to_many :object_types, UaArchaeology.ObjectType,
        join_through: UaArchaeology.FindObjectType,
        join_keys: [find_id: :id, parameter_id: :id], on_delete: :delete_all
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :topo])
    |> validate_required([:title, :topo])
  end
end
