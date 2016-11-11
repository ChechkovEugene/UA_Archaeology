defmodule UaArchaeology.TestHelper do
  alias UaArchaeology.Repo
  alias UaArchaeology.User
  alias UaArchaeology.Role
  alias UaArchaeology.Culture

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
end
