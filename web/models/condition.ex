defmodule UaArchaeology.Condition do
  use UaArchaeology.Web, :model

  schema "conditions" do
    field :name, :string
    belongs_to :user, UaArchaeology.User
    many_to_many :finds, UaArchaeology.Find, join_through: UaArchaeology.FindCondition
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def alphabetical(query) do
    from c in query, order_by: c.id
  end

  def names_and_ids(query) do
    from c in query, select: {c.name, c.id}
  end

end
