# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     UaArchaeology.Repo.insert!(%UaArchaeology.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias UaArchaeology.Repo
alias UaArchaeology.Role
alias UaArchaeology.User

role = %Role{}
  |> Role.changeset(%{name: "Admin Role", admin: true})
  |> Repo.insert!

admin = %User{}
  |> User.changeset(%{username: "admin", email: "test.archaeo@gmail.com",
    password: "test", password_confirmation: "test", role_id: role.id})
  |> Repo.insert!
