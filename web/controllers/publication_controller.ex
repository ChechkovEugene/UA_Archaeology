defmodule UaArchaeology.PublicationController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Publication

  plug :scrub_params, "publication" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    publications = Repo.all(Publication)
    # publications = Repo.all(assoc(conn.assigns[:user], :publications))
    render(conn, "index.html", publications: publications)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:publications)
      |> Publication.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"publication" => publication_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:publications)
      |> Publication.changeset(publication_params)

    case Repo.insert(changeset) do
      {:ok, _publication} ->
        conn
        |> put_flash(:info, "Publication created successfully.")
        |> redirect(to: user_publication_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    publication = Repo.get!(Publication, id)
    # publication = Repo.get!(assoc(conn.assigns[:user], :publications), id)
    render(conn, "show.html", publication: publication)
  end

  def edit(conn, %{"id" => id}) do
    publication = Repo.get!(assoc(conn.assigns[:user], :publications), id)
    changeset = Publication.changeset(publication)
    render(conn, "edit.html", publication: publication, changeset: changeset)
  end

  def update(conn, %{"id" => id, "publication" => publication_params}) do
      publication = Repo.get!(assoc(conn.assigns[:user], :publications), id)
      changeset = Publication.changeset(publication, publication_params)

      case Repo.update(changeset) do
        {:ok, publication} ->
          conn
          |> put_flash(:info, "Publication updated successfully.")
          |> redirect(to: user_publication_path(conn, :show, conn.assigns[:user], publication))
        {:error, changeset} ->
          render(conn, "edit.html", publication: publication, changeset: changeset)
      end
  end

  def delete(conn, %{"id" => id}) do
      publication = Repo.get!(assoc(conn.assigns[:user], :publications), id)

      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(publication)

      conn
      |> put_flash(:info, "Публікація успішно видалена.")
      |> redirect(to: user_publication_path(conn, :index, conn.assigns[:user]))
    end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(UaArchaeology.User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ -> invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Невірний користувач!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    user = get_session(conn, :current_user)
    if user && Integer.to_string(user.id) == conn.params["user_id"] do
      conn
    else
      conn
      |> put_flash(:error, "Ви не авторизовані для редагування цієї публікації!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
