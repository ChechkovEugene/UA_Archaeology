defmodule UaArchaeology.Find do
  use UaArchaeology.Web, :model

  schema "finds" do
    field :title, :string
    field :idn, :string
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
    many_to_many :site_types, UaArchaeology.SiteType,
        join_through: UaArchaeology.FindSiteType,
        join_keys: [find_id: :id, parameter_id: :id], on_delete: :delete_all
    many_to_many :cultures, UaArchaeology.Culture,
        join_through: UaArchaeology.FindCulture,
        join_keys: [find_id: :id, parameter_id: :id], on_delete: :delete_all
    field :description, :string
    many_to_many :authors, UaArchaeology.Author,
        join_through: UaArchaeology.FindAuthor,
        join_keys: [find_id: :id, parameter_id: :id], on_delete: :delete_all
    many_to_many :publications, UaArchaeology.Publication,
        join_through: UaArchaeology.FindPublication,
        join_keys: [find_id: :id, parameter_id: :id], on_delete: :delete_all
    field :register, :string
    field :passport, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :idn, :topo])
    |> validate_required([:title, :idn, :topo])
  end
end
