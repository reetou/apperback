defmodule Apperback.Configuration do
  def test_db() do
    case Mongo.find_one(:mongo, "projects", %{}) do
      {:error, _} = error -> error
      _ -> :ok
    end
  end
end
