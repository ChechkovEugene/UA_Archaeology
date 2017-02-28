defmodule UaArchaeology.ConditionView do
  use UaArchaeology.Web, :view

  def conditions_for_select(conditions) do
    conditions
    |> Enum.map(&["#{&1.name}": &1.id])
    |> List.flatten
  end
end
