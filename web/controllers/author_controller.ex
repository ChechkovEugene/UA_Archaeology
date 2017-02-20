defmodule UaArchaeology.AuthorController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Author

  plug :scrub_params, "author" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    authors = Repo.all(Author)
    # authors = Repo.all(assoc(conn.assigns[:user], :authors))
    render(conn, "index.html", authors: authors)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:authors)
      |> Author.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:authors)
      |> Author.changeset(author_params)

    case Repo.insert(changeset) do
      {:ok, _author} ->
        conn
        |> put_flash(:info, "Автор успішно створений!")
        |> redirect(to: user_author_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    # author = Repo.get!(assoc(conn.assigns[:user], :authors), id)
    render(conn, "show.html", author: author)
  end

  def edit(conn, %{"id" => id}) do
    author = Repo.get!(assoc(conn.assigns[:user], :authors), id)
    changeset = Author.changeset(author)
    render(conn, "edit.html", author: author, changeset: changeset)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
      author = Repo.get!(assoc(conn.assigns[:user], :authors), id)
      changeset = Author.changeset(author, author_params)

      case Repo.update(changeset) do
        {:ok, author} ->
          conn
          |> put_flash(:info, "Автора було успішно змінено.")
          |> redirect(to: user_author_path(conn, :show, conn.assigns[:user],
            author))
        {:error, changeset} ->
          render(conn, "edit.html", author: author, changeset: changeset)
      end
  end

  def delete(conn, %{"id" => id}) do
      author = Repo.get!(assoc(conn.assigns[:user], :authors), id)

      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(author)

      conn
      |> put_flash(:info, "Автора було успішно видалено.")
      |> redirect(to: user_author_path(conn, :index, conn.assigns[:user]))
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
      |> put_flash(:error, "Ви не авторизовані для редагування цього
      користувача!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
