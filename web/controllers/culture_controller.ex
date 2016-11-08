defmodule UaArchaeology.CultureController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Culture

  def index(conn, _params) do
    cultures = Repo.all(Culture)
    render(conn, "index.html", cultures: cultures)
  end

  def new(conn, _params) do
    changeset = Culture.changeset(%Culture{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"culture" => culture_params}) do
    changeset = Culture.changeset(%Culture{}, culture_params)

    case Repo.insert(changeset) do
      {:ok, _culture} ->
        conn
        |> put_flash(:info, "Culture created successfully.")
        |> redirect(to: culture_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    culture = Repo.get!(Culture, id)
    render(conn, "show.html", culture: culture)
  end

  def edit(conn, %{"id" => id}) do
    culture = Repo.get!(Culture, id)
    changeset = Culture.changeset(culture)
    render(conn, "edit.html", culture: culture, changeset: changeset)
  end

  def update(conn, %{"id" => id, "culture" => culture_params}) do
    culture = Repo.get!(Culture, id)
    changeset = Culture.changeset(culture, culture_params)

    case Repo.update(changeset) do
      {:ok, culture} ->
        conn
        |> put_flash(:info, "Culture updated successfully.")
        |> redirect(to: culture_path(conn, :show, culture))
      {:error, changeset} ->
        render(conn, "edit.html", culture: culture, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    culture = Repo.get!(Culture, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(culture)

    conn
    |> put_flash(:info, "Culture deleted successfully.")
    |> redirect(to: culture_path(conn, :index))
  end
end
