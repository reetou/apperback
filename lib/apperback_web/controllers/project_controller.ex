defmodule ApperbackWeb.ProjectController do
  use ApperbackWeb, :controller

  def list(conn, _) do
    json(conn, %{})
  end

  def create(conn, %{"project" => _project}) do
    json(conn, %{})
  end

  def show(conn, %{"id" => _id}) do
    json(conn, %{})
  end
end
