defmodule ApperbackWeb.PageController do
  use ApperbackWeb, :controller

  def list(conn, _) do
    json(conn, %{})
  end

  def create(conn, %{"project" => project}) do
    json(conn, %{})
  end

  def show(conn, %{"id" => _id}) do
    json(conn, %{})
  end
end
