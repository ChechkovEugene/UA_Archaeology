defmodule UaArchaeology.Factory do
  use ExMachina.Ecto, repo: UaArchaeology.Repo

  alias UaArchaeology.Role
  alias UaArchaeology.User
  alias UaArchaeology.Culture
  alias UaArchaeology.ObjectType
  alias UaArchaeology.SiteType
  alias UaArchaeology.ResearchLevel
  alias UaArchaeology.Condition
  alias UaArchaeology.Publication
  alias UaArchaeology.Author
  alias UaArchaeology.NaturalResearch

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

  def object_type_factory do
    %ObjectType{
      name: "ObjectType",
      user: build(:user)
    }
  end

  def site_type_factory do
    %SiteType{
      name: "SiteType",
      user: build(:user)
    }
  end

  def research_level_factory do
    %ResearchLevel{
      name: "ResearchLevel",
      user: build(:user)
    }
  end

  def condition_factory do
    %Condition{
      name: "Condition",
      user: build(:user)
    }
  end

  def author_factory do
    %Author{
      name: "Author",
      user: build(:user)
    }
  end

  def publication_factory do
    %Publication{
      name: "Publication",
      user: build(:user)
    }
  end

  def natural_research_factory do
    %NaturalResearch{
      name: "NaturalResearch",
      user: build(:user)
    }
  end
end
