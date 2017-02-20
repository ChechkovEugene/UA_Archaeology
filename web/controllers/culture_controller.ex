defmodule UaArchaeology.CultureController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Culture

  plug :scrub_params, "culture" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    cultures = Repo.all(Culture)
    # cultures = Repo.all(assoc(conn.assigns[:user], :cultures))
    render(conn, "index.html", cultures: cultures)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:cultures)
      |> Culture.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"culture" => culture_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:cultures)
      |> Culture.changeset(culture_params)

    case Repo.insert(changeset) do
      {:ok, _culture} ->
        conn
        |> put_flash(:info, "Археологічна культура успішно створена!")
        |> redirect(to: user_culture_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    culture = Repo.get!(Culture, id)
    # culture = Repo.get!(assoc(conn.assigns[:user], :cultures), id)
    render(conn, "show.html", culture: culture)
  end

  def edit(conn, %{"id" => id}) do
    culture = Repo.get!(assoc(conn.assigns[:user], :cultures), id)
    changeset = Culture.changeset(culture)
    render(conn, "edit.html", culture: culture, changeset: changeset)
  end

  def update(conn, %{"id" => id, "culture" => culture_params}) do
      culture = Repo.get!(assoc(conn.assigns[:user], :cultures), id)
      changeset = Culture.changeset(culture, culture_params)

      case Repo.update(changeset) do
        {:ok, culture} ->
          conn
          |> put_flash(:info, "Археологічну культуру було успішно змінено.")
          |> redirect(to: user_culture_path(conn, :show, conn.assigns[:user], culture))
        {:error, changeset} ->
          render(conn, "edit.html", culture: culture, changeset: changeset)
      end
  end

  def delete(conn, %{"id" => id}) do
      culture = Repo.get!(assoc(conn.assigns[:user], :cultures), id)

      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(culture)

      conn
      |> put_flash(:info, "Археологічну культуру було успішно видалено.")
      |> redirect(to: user_culture_path(conn, :index, conn.assigns[:user]))
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
      |> put_flash(:error, "Ви не авторизовані для редагування цієї
      археологічної культури!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
