defmodule UaArchaeology.RoleChecker do
  alias UaArchaeology.Repo
  alias UaArchaeology.Role

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end
end
