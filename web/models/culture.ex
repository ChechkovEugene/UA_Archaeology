defmodule UaArchaeology.Culture do
  use UaArchaeology.Web, :model

  schema "cultures" do
    field :name, :string
    belongs_to :user, UaArchaeology.User
    
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
end
