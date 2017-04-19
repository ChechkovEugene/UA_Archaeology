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
alias UaArchaeology.SiteType
alias UaArchaeology.Culture
alias UaArchaeology.NaturalResearch

import Ecto.Query, only: [from: 2]

find_or_create_role = fn role_name, admin ->
  case Repo.all(from r in Role, where: r.name == ^role_name and r.admin == ^admin) do
    [] ->
      %Role{}
      |> Role.changeset(%{name: role_name, admin: admin})
      |> Repo.insert!()
    _ ->
      IO.puts "Role: #{role_name} already exists, skipping"
  end
end

find_or_create_user = fn username, email, role ->
  case Repo.all(from u in User, where: u.username == ^username and u.email == ^email) do
    [] ->
      %User{}
      |> User.changeset(%{username: username, email: email, password: "test", password_confirmation: "test", role_id: role.id})
      |> Repo.insert!()
    _ ->
      IO.puts "User: #{username} already exists, skipping"
  end
end


find_or_create_site_type = fn name, user ->
  case Repo.all(from st in SiteType, where: st.name== ^name) do
    [] ->
      %SiteType{}
      |> SiteType.changeset(%{name: name, user_id: user.id})
      |> Repo.insert!()
    _ ->
      IO.puts "Site type: #{name} already exists, skipping"
  end
end

find_or_create_culture = fn name, user ->
  case Repo.all(from c in Culture, where: c.name== ^name) do
    [] ->
      %Culture{}
      |> Culture.changeset(%{name: name, user_id: user.id})
      |> Repo.insert!()
    _ ->
      IO.puts "Culture: #{name} already exists, skipping"
  end
end

find_or_create_culture = fn name, user ->
  case Repo.all(from c in Culture, where: c.name== ^name) do
    [] ->
      %Culture{}
        |> Culture.changeset(%{name: name, user_id: user.id})
        |> Repo.insert!()
      _ ->
        IO.puts "Culture: #{name} already exists, skipping"
    end
end

find_or_create_condition = fn name, user ->
  case Repo.all(from c in Condition, where: c.name== ^name) do
    [] ->
      %Condition{}
      |> Condition.changeset(%{name: name, user_id: user.id})
      |> Repo.insert!()
    _ ->
      IO.puts "Condition: #{name} already exists, skipping"
  end
end

find_or_create_natural_research = fn name, user ->
  case Repo.all(from nr in NaturalResearch, where: nr.name== ^name) do
    [] ->
      %NaturalResearch{}
      |> NaturalResearch.changeset(%{name: name, user_id: user.id})
      |> Repo.insert!()
    _ ->
      IO.puts "Natural research: #{name} already exists, skipping"
  end
end

_user_role  = find_or_create_role.("User Role", false)
admin_role  = find_or_create_role.("Admin Role", true)
admin_user = find_or_create_user.("admin", "admin@test.com", admin_role)

_site_type = find_or_create_site_type.("поселення", admin_user)
_site_type = find_or_create_site_type.("городище", admin_user)
_site_type = find_or_create_site_type.("посад", admin_user)
_site_type = find_or_create_site_type.("виробничі осередки", admin_user)
_site_type = find_or_create_site_type.("скарб", admin_user)
_site_type = find_or_create_site_type.("окрема знахідка", admin_user)
_site_type = find_or_create_site_type.("могильник ґрунтовий", admin_user)
_site_type = find_or_create_site_type.("могильник курганний", admin_user)
_site_type = find_or_create_site_type.("окреме поховання", admin_user)
_site_type = find_or_create_site_type.("культові споруди", admin_user)
_site_type = find_or_create_site_type.("місце жертвоприношень", admin_user)
_site_type = find_or_create_site_type.("місцезнаходження", admin_user)

_culture = find_or_create_culture.("зарубинецька", admin_user)
_culture = find_or_create_culture.("пізньозарубинецька", admin_user)
_culture = find_or_create_culture.("липицька", admin_user)
_culture = find_or_create_culture.("вельбарська", admin_user)
_culture = find_or_create_culture.("пшеворська", admin_user)
_culture = find_or_create_culture.("зубрицька", admin_user)
_culture = find_or_create_culture.("карпатських курганів", admin_user)
_culture = find_or_create_culture.("черняхівська", admin_user)
_culture = find_or_create_culture.("київська", admin_user)
_culture = find_or_create_culture.("празька", admin_user)
_culture = find_or_create_culture.("колочинська", admin_user)
_culture = find_or_create_culture.("пеньківська", admin_user)
_culture = find_or_create_culture.("сахнівська", admin_user)
_culture = find_or_create_culture.("волинцевська", admin_user)
_culture = find_or_create_culture.("роменська", admin_user)
_culture = find_or_create_culture.("райковецька", admin_user)

_culture = find_or_create_condition.("задерноване", admin_user)
_culture = find_or_create_condition.("поросле лісом чи чагарниками", admin_user)
_culture = find_or_create_condition.("ореться", admin_user)
_culture = find_or_create_condition.("забудовується", admin_user)
_culture = find_or_create_condition.("кар’єри", admin_user)
_culture = find_or_create_condition.("розмивається водою", admin_user)

_natural_research = find_or_create_natural_research.("антропологічний", admin_user)
_natural_research = find_or_create_natural_research.("археозоологічний", admin_user)
_natural_research = find_or_create_natural_research.("палеоботанічний", admin_user)
_natural_research = find_or_create_natural_research.("споропилковий", admin_user)
_natural_research = find_or_create_natural_research.("фізико-хімічний", admin_user)
_natural_research = find_or_create_natural_research.("ґрунтознавчий", admin_user)
_natural_research = find_or_create_natural_research.("геофізичний", admin_user)
_natural_research = find_or_create_natural_research.("металографічний", admin_user)
_natural_research = find_or_create_natural_research.("петрографічний", admin_user)
