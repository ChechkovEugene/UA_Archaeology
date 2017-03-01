defmodule UaArchaeology.FindController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Find
  alias UaArchaeology.Condition
  alias UaArchaeology.ResearchLevel
  alias UaArchaeology.FindCondition
  alias UaArchaeology.FindResearchLevel
  alias UaArchaeology.ObjectType
  alias UaArchaeology.FindObjectType
  alias UaArchaeology.SiteType
  alias UaArchaeology.FindSiteType
  alias UaArchaeology.Culture
  alias UaArchaeology.FindCulture
  alias UaArchaeology.Author
  alias UaArchaeology.FindAuthor
  alias UaArchaeology.Publication
  alias UaArchaeology.FindPublication

  plug :scrub_params, "find" when action in [:create, :update]
  plug :assign_user
  # plug :assign_user_nullable when action in [:index]
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
  # plug :set_authorization_flag when action in [:show]
  plug :load_conditions     when action in [:new, :create, :edit, :update]
  plug :load_research_levels     when action in [:new, :create, :edit, :update]
  plug :load_object_types     when action in [:new, :create, :edit, :update]
  plug :load_site_types when action in [:new, :create, :edit, :update]
  plug :load_cultures when action in [:new, :create, :edit, :update]
  plug :load_authors when action in [:new, :create, :edit, :update]
  plug :load_publications when action in [:new, :create, :edit, :update]

  def index(conn, _params) do
    # finds = Repo.all(assoc(conn.assigns[:user], :finds))
    finds = Repo.all(Find)
    render(conn, "index.html", finds: finds)
  end

  def new(conn, _params) do
    changeset = conn.assigns[:user]
      |> build_assoc(:finds)
      |> Find.changeset()
    render(conn, "new.html", changeset: changeset, find_conditions_ids: [],
    find_research_levels_ids: [], find_object_types_ids: [],
    find_site_types_ids: [], find_cultures_ids: [], find_authors_ids: [],
    find_publications_ids: [])
  end

  def create(conn, %{"find" => find_params}) do

    checked_conditions_ids = checked_ids(conn, "checked_conditions")
    checked_research_levels_ids = checked_ids(conn, "checked_research_levels")
    checked_object_types_ids = checked_ids(conn, "checked_object_types")
    checked_site_types_ids = checked_ids(conn, "checked_site_types")
    checked_cultures_ids = checked_ids(conn, "checked_cultures")
    checked_authors_ids = checked_ids(conn, "checked_authors")
    checked_publications_ids = checked_ids(conn, "checked_publications")

    changeset = conn.assigns[:user]
      |> build_assoc(:finds)
      |> Find.changeset(find_params)

    case Repo.insert(changeset) do
      {:ok, find} ->
        find_id = find.id
        do_update_intermediate_table(FindCondition, find_id, [],
          checked_conditions_ids)
        do_update_intermediate_table(FindResearchLevel, find_id, [],
          checked_research_levels_ids)
        do_update_intermediate_table(FindObjectType, find_id, [],
          checked_object_types_ids)
        do_update_intermediate_table(FindSiteType, find_id, [],
          checked_site_types_ids)
        do_update_intermediate_table(FindCultures, find_id, [],
          checked_cultures_ids)
        do_update_intermediate_table(FindAuthors, find_id, [],
          checked_authors_ids)
        do_update_intermediate_table(FindPublications, find_id, [],
          checked_publications_ids)
        conn
        |> put_flash(:info, "Археологічна пам'ятка успішно створена!")
        |> redirect(to: user_find_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset,
        find_conditions_ids: checked_conditions_ids,
        find_research_levels_ids: checked_research_levels_ids,
        find_object_types_ids: checked_object_types_ids,
        find_site_types_ids: checked_site_types_ids,
        find_cultures_ids: checked_cultures_ids,
        find_authors_ids: checked_authors_ids,
        find_publications_ids: checked_publications_ids)
    end
  end

  def show(conn, %{"id" => id}) do
    find = Repo.get!(Find, id)
    find = Repo.preload find, [:conditions, :research_levels, :object_types,
      :site_types, :cultures, :authors, :publications]
    # find = Repo.get!(assoc(conn.assigns[:user], :finds), id)
    render(conn, "show.html", find: find)
  end

  def edit(conn, %{"id" => id}) do
    find = Repo.get!(assoc(conn.assigns[:user], :finds), id)
    find = Repo.preload find, [:conditions, :research_levels, :object_types,
      :site_types, :cultures, :authors, :publications]

    finds_conditions_ids = find.conditions |> Enum.map(&(&1.id))
    find_research_levels_ids = find.research_levels |> Enum.map(&(&1.id))
    find_object_types_ids = find.object_types |> Enum.map(&(&1.id))
    find_site_types_ids = find.site_types |> Enum.map(&(&1.id))
    find_cultures_ids = find.cultures |> Enum.map(&(&1.id))
    find_authors_ids = find.authors |> Enum.map(&(&1.id))
    find_publications_ids = find.publications |> Enum.map(&(&1.id))

    changeset = Find.changeset(find)
    render(conn, "edit.html", find: find, changeset: changeset,
                              finds_conditions_ids: finds_conditions_ids,
                              find_research_levels_ids: find_research_levels_ids,
                              find_object_types_ids: find_object_types_ids,
                              find_site_types_ids: find_site_types_ids,
                              find_cultures_ids: find_cultures_ids,
                              find_authors_ids: find_authors_ids,
                              find_publications_ids: find_publications_ids)
  end

  def update(conn, %{"id" => id, "find" => find_params}) do
    find = Repo.get!(assoc(conn.assigns[:user], :finds), id)
    find = Repo.preload find, [:conditions, :research_levels, :object_types,
      :site_types, :cultures, :authors, :publications]

    finds_conditions_ids = find.conditions |> Enum.map(&(&1.id))
    find_research_levels_ids = find.research_levels |> Enum.map(&(&1.id))
    find_object_types_ids = find.object_types |> Enum.map(&(&1.id))
    find_site_types_ids = find.site_types |> Enum.map(&(&1.id))
    find_cultures_ids = find.cultures |> Enum.map(&(&1.id))
    find_authors_ids = find.authors |> Enum.map(&(&1.id))
    find_publications_ids = find.publications |> Enum.map(&(&1.id))

    changeset = Find.changeset(find, find_params)

    find_id = find.id

    checked_conditions_ids = checked_ids(conn, "checked_conditions")
    checked_research_levels_ids = checked_ids(conn, "checked_research_levels")
    checked_object_types_ids = checked_ids(conn, "checked_object_types")
    checked_site_types_ids = checked_ids(conn, "checked_site_types")
    checked_cultures_ids = checked_ids(conn, "checked_cultures")
    checked_authors_ids = checked_ids(conn, "checked_authors")
    checked_publications_ids = checked_ids(conn, "checked_publications")

    case Repo.update(changeset) do
      {:ok, find} ->
        do_update_intermediate_table(FindCondition, find_id, [],
          checked_conditions_ids)
        do_update_intermediate_table(FindResearchLevel, find_id, [],
          checked_research_levels_ids)
        do_update_intermediate_table(FindObjectType, find_id, [],
          checked_object_types_ids)
        do_update_intermediate_table(FindSiteType, find_id, [],
          checked_site_types_ids)
        do_update_intermediate_table(FindCulture, find_id, [],
          checked_cultures_ids)
        do_update_intermediate_table(FindAuthors, find_id, [],
          checked_authors_ids)
        do_update_intermediate_table(FindPublications, find_id, [],
            checked_publications_ids)
        conn
        |> put_flash(:info, "Археологічна пам'ятка успішно оновлена.")
        |> redirect(to: user_find_path(conn, :show, conn.assigns[:user], find))
      {:error, changeset} ->
        render(conn, "edit.html", find: find, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    find = Repo.get!(assoc(conn.assigns[:user], :finds), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(find)

    conn
    |> put_flash(:info, "Археологічна пам'ятка успішно видалена.")
    |> redirect(to: user_find_path(conn, :index, conn.assigns[:user]))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => "-1"} ->
        assign(conn, :user, nil)
      %{"user_id" => user_id} ->
        case Repo.get(UaArchaeology.User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ ->
        invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Невірний користувач!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "Ви не авторизовані для редагування цієї пам'ятки!")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end

  defp set_authorization_flag(conn, _opts) do
    assign(conn, :author_or_admin, is_authorized_user?(conn))
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    (user && (Integer.to_string(user.id) == conn.params["user_id"] || UaArchaeology.RoleChecker.is_admin?(user)))
  end

  defp filter_true_checkbox(checkbox_list) when checkbox_list == nil, do: []

  defp filter_true_checkbox(checkbox_list) do
    checkbox_list
    |> Enum.map(&(do_get_id_if_true(&1)))
    |> Enum.filter(&(&1 != nil))
  end

  defp do_get_id_if_true(tuple) do
    case tuple do
      {id, "true"} -> String.to_integer id
      _ -> nil
    end
  end

  defp do_update_intermediate_table(model, find_id, list_of_existing_ids, list_of_checked_ids) do
    ids_to_delete = list_of_existing_ids -- list_of_checked_ids
    ids_to_insert = (list_of_checked_ids -- list_of_existing_ids) -- ids_to_delete

    if length(ids_to_delete) > 0 do
      query = from c in model, where: c.find_id == ^find_id and c.parameter_id in ^ids_to_delete
      Repo.delete_all query
    end

    if length(ids_to_insert) > 0 do
      data = ids_to_insert |> Enum.map(&([find_id: find_id, parameter_id: &1]))
      Repo.insert_all model, data
    end
  end

  defp checked_ids(conn, checked_list) when checked_list == nil, do: []
  defp checked_ids(conn, checked_list) do
    conn.params[checked_list]
    |> filter_true_checkbox
  end

  defp load_conditions(conn, _) do
    query =
      Condition
      |> Condition.alphabetical
      |> Condition.names_and_ids
    conditions = Repo.all query
    assign(conn, :conditions, conditions)
  end

  defp load_research_levels(conn, _) do
    query =
      ResearchLevel
      |> ResearchLevel.alphabetical
      |> ResearchLevel.names_and_ids
    research_levels = Repo.all query
    assign(conn, :research_levels, research_levels)
  end

  defp load_object_types(conn, _) do
    query =
      ObjectType
      |> ObjectType.alphabetical
      |> ObjectType.names_and_ids
    object_types = Repo.all query
    assign(conn, :object_types, object_types)
  end

  defp load_site_types(conn, _) do
    query =
      SiteType
      |> SiteType.alphabetical
      |> SiteType.names_and_ids
    site_types = Repo.all query
    assign(conn, :site_types, site_types)
  end

  defp load_cultures(conn, _) do
    query =
      Culture
      |> Culture.alphabetical
      |> Culture.names_and_ids
    cultures = Repo.all query
    assign(conn, :cultures, cultures)
  end

  defp load_authors(conn, _) do
    query =
      Author
      |> Author.alphabetical
      |> Author.names_and_ids
    authors = Repo.all query
    assign(conn, :authors, authors)
  end

  defp load_publications(conn, _) do
    query =
      Publication
      |> Publication.alphabetical
      |> Publication.names_and_ids
    publications = Repo.all query
    assign(conn, :publications, publications)
  end
end
