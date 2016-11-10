defmodule UaArchaeology.CultureController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Culture

  plug :assign_user

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
        |> redirect(to: user_culture_path(conn, :index, conn.assigns[:user]))
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
        |> redirect(to: user_culture_path(conn, :show, conn.assigns[:user], culture))
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
    |> redirect(to: user_culture_path(conn, :index, conn.assigns[:user]))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        user = Repo.get(UaArchaeology.User, user_id)
        assign(conn, :user, user)
      _->
        conn
    end
  end
end
