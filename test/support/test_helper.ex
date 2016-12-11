defmodule UaArchaeology.TestHelper do
  alias UaArchaeology.Repo
  alias UaArchaeology.User
  alias UaArchaeology.Role
  alias UaArchaeology.Culture
  alias UaArchaeology.ObjectType
  alias UaArchaeology.SiteType
  alias UaArchaeology.Author
  alias UaArchaeology.Publication
  alias UaArchaeology.Condition
  alias UaArchaeology.ResearchLevel

  import Ecto, only: [build_assoc: 2]

  def create_role(%{name: name, admin: admin}) do
    Role.changeset(%Role{}, %{name: name, admin: admin})
    |> Repo.insert
  end

  def create_user(role, %{email: email, username: username,
    password: password, password_confirmation: password_confirmation}) do
      role
      |> build_assoc(:users)
      |> User.changeset(%{email: email, username: username, password: password,
        password_confirmation: password_confirmation})
      |> Repo.insert
  end

  def create_culture(user, %{name: name}) do
    user
    |> build_assoc(:cultures)
    |> Culture.changeset(%{name: name})
    |> Repo.insert
  end

  def create_object_type(user, %{name: name}) do
    user
    |> build_assoc(:object_type)
    |> ObjectType.changeset(%{name: name})
    |> Repo.insert
  end

  def create_site_type(user, %{name: name}) do
    user
    |> build_assoc(:site_type)
    |> SiteType.changeset(%{name: name})
    |> Repo.insert
  end

  def create_research_level(user, %{name: name}) do
    user
    |> build_assoc(:research_level)
    |> ResearchLevel.changeset(%{name: name})
    |> Repo.insert
  end

  def create_condition(user, %{name: name}) do
    user
    |> build_assoc(:condition)
    |> Condition.changeset(%{name: name})
    |> Repo.insert
  end

  def create_author(user, %{name: name}) do
    user
    |> build_assoc(:author)
    |> Author.changeset(%{name: name})
    |> Repo.insert
  end

  def create_publication(user, %{name: name}) do
    user
    |> build_assoc(:publication)
    |> Publication.changeset(%{name: name})
    |> Repo.insert
  end
end
