defmodule Apperback.Configuration do
  def test_db() do
    {:ok, _} = Mongo.find_one(:mongo, "projects", %{})
  end
end
