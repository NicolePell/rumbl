defmodule Rumbl.Repo do
  
  @moduledoc """
  In memory repository.
  """

  def get(module, id) do
    Enum.find all(module), fn map ->
      map.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end

  def all(Rumbl.User) do
    [
      %Rumbl.User{id: "1", name: "Sharkey Anchorbottom", username: "sharkey", password: "nicole"},
      %Rumbl.User{id: "2", name: "Sea-Legs Swordskull", username: "sealegs", password: "gel"},
      %Rumbl.User{id: "3", name: "Gristle Rattlebones", username: "gristle", password: "naveed"},
      %Rumbl.User{id: "4", name: "Shudders Swindles", username: "shudders", password: "hannes"}
    ]
  end
  def all(_module), do: []

end
