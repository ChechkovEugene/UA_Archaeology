defmodule UaArchaeology.FindCulture do
  use UaArchaeology.Web, :model

  @primary_key {:id, :id, autogenerate: false}

  schema "finds_cultures" do
    belongs_to :find, UaArchaeology.Find
    belongs_to :culture, UaArchaeology.Culture, foreign_key: :parameter_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:find_id, :culture_id])
    |> validate_required([:find_id, :culture_id])
    |> unique_constraint(:find_id, :culture_id)
  end
end
