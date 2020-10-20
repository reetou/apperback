defmodule ApperbackWeb.ProjectController do
  alias Apperback.Project
  alias ApperbackWeb.ErrorResponse
  alias Apperback.User

  use ApperbackWeb, :controller

  def list(%{assigns: %{current_user: %User{id: id}}} = conn, _) do
    json(conn, %{projects: Project.list(id)})
  end

  def create(%{assigns: %{current_user: %User{id: id}}} = conn, %{"project" => project}) do
    %Project{} = project = Project.create(%Project{user_id: id}, project)
    json(conn, %{project: project})
  end

  def create(%{assigns: %{current_user: %User{id: id}}} = conn, _params) do
    %Project{} = project = Project.create_default_project(id)
    json(conn, %{project: project})
  end

  def update(%{assigns: %{current_user: %User{id: user_id}}} = conn, %{
        "id" => id,
        "project" => data
      }) do
    with %Project{id: _} = project <- Project.get_for_user(user_id, id) do
      %Project{} = project = Project.update(project, data)
      json(conn, %{project: project})
    else
      nil -> ErrorResponse.render_error(conn, 404)
      {:error, _} = error -> error
    end
  end

  def show(%{assigns: %{current_user: %User{id: user_id}}} = conn, %{"id" => id}) do
    user_id
    |> Project.get_for_user(id)
    |> case do
      nil -> ErrorResponse.render_error(conn, 404)
      %Project{} = project -> json(conn, %{project: project})
      {:error, _} = error -> error
    end
  end
end
