defmodule UaArchaeology.Find do
  use UaArchaeology.Web, :model

  schema "finds" do
    field :title, :string
    field :topo, :string
    belongs_to :user, UaArchaeology.User

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
