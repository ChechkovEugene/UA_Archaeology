defmodule UaArchaeology.Factory do
  use ExMachina.Ecto, repo: UaArchaeology.Repo

  alias UaArchaeology.Role
  alias UaArchaeology.User
  alias UaArchaeology.Culture

  def role_factory do
    %Role{
      name: sequence(:name, &"Test Role #{&1}"),
      admin: false
    }
  end
  def user_factory do
    %User{
      username: sequence(:username, &"User #{&1}"),
      email: "test@test.com",
      password: "test1234",
      password_confirmation: "test1234",
      password_digest: Comeonin.Bcrypt.hashpwsalt("test1234"),
      role: build(:role)
    }
  end

  def culture_factory do
    %Culture{
      name: "Culture",
      user: build(:user)
    }
  end
end
