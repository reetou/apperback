defmodule ApperbackWeb.ProjectController do
  alias Apperback.Project
  alias ApperbackWeb.ErrorResponse

  use ApperbackWeb, :controller


  def list(conn, _) do
    json(conn, %{})
  end

  def create(conn, %{"project" => project}) do
    %Project{} = project = Project.create(%Project{}, project)
    json(conn, %{project: project})
  end

  def create(conn, _params) do
    %Project{} = project = Project.create_default_project()
    json(conn, %{project: project})
  end

  def update(conn, %{"id" => id, "project" => data}) do
    with %Project{id: id} = project <- Project.get(id) do
      %Project{} = project = Project.update(project, data)
      json(conn, %{project: project})
    else
      nil -> ErrorResponse.render_error(conn, 404)
      {:error, _} = error -> error
    end
  end

  def show(conn, %{"id" => id}) do
    id
    |> Project.get()
    |> case do
         nil -> ErrorResponse.render_error(conn, 404)
         %Project{} = project -> json(conn, %{project: project})
         {:error, _} = error -> error
       end
  end
end
