defmodule Apperback.Factories.Utils do
  alias ExMachina

  def stringify_keys(map = %{}) do
    map
    |> case do
      x when is_struct(x) -> Map.from_struct(x)
      x -> x
    end
    |> Enum.map(fn {k, v} ->
      v =
        case v do
          %DateTime{} = x -> DateTime.truncate(x, :millisecond)
          %{} = x -> stringify_keys(x)
          x -> x
        end

      {"#{k}", v}
    end)
    |> Enum.into(%{})
  end

  def text() do
    ExMachina.sequence("text")
  end
end
