defmodule UaArchaeology.FindAuthor do
  use UaArchaeology.Web, :model

  @primary_key {:id, :id, autogenerate: false}

  schema "finds_authors" do
    belongs_to :find, UaArchaeology.Find
    belongs_to :author, UaArchaeology.Author, foreign_key: :parameter_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:find_id, :author_id])
    |> validate_required([:find_id, :condition_id])
    |> unique_constraint(:find_id, :condition_id)
  end
end
