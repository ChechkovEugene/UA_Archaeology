defmodule UaArchaeology.NaturalResearchController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.NaturalResearch

  plug :scrub_params, "natural_research" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    natural_researches = Repo.all(NaturalResearch)
    # research_levels = Repo.all(assoc(conn.assigns[:user], :research_levels))
    render(conn, "index.html", natural_researches: natural_researches)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:natural_researches)
      |> NaturalResearch.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"natural_research" => natural_research_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:natural_researches)
      |> NaturalResearch.changeset(natural_research_params)

    case Repo.insert(changeset) do
      {:ok, _natural_research} ->
        conn
        |> put_flash(:info, "Вид природничих досліджень успішно створений!")
        |> redirect(to: user_natural_research_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    natural_research = Repo.get!(NaturalResearch, id)
    # research_level = Repo.get!(assoc(conn.assigns[:user], :research_levels), id)
    render(conn, "show.html", natural_research: natural_research)
  end

  def edit(conn, %{"id" => id}) do
    natural_research = Repo.get!(assoc(conn.assigns[:user], :natural_researches), id)
    changeset = NaturalResearch.changeset(natural_research)
    render(conn, "edit.html", natural_research: natural_research, changeset: changeset)
  end

  def update(conn, %{"id" => id, "natural_research" => natural_research_params}) do
    natural_research = Repo.get!(assoc(conn.assigns[:user], :natural_researches), id)
    changeset = NaturalResearch.changeset(natural_research, natural_research_params)

    case Repo.update(changeset) do
      {:ok, natural_research} ->
        conn
        |> put_flash(:info, "Вид природничих досліджень було успішно змінено.")
        |> redirect(to: user_natural_research_path(conn, :show, conn.assigns[:user],
          natural_research))
      {:error, changeset} ->
        render(conn, "edit.html", natural_research: natural_research, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    natural_research = Repo.get!(assoc(conn.assigns[:user], :natural_researches), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(natural_research)

    conn
    |> put_flash(:info, "Вид природничих досліджень було успішно видалено.")
    |> redirect(to: user_natural_research_path(conn, :index, conn.assigns[:user]))
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
      виду природничих досліджень!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
