defmodule UaArchaeology.FindView do
  use UaArchaeology.Web, :view

  def conditions_for_select(conditions) do
    conditions
    |> Enum.map(&["#{&1.name}": &1.id])
    |> List.flatten
  end

  def research_levels_for_select(research_levels) do
    research_levels
    |> Enum.map(&["#{&1.name}": &1.id])
    |> List.flatten
  end
end
