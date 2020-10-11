defmodule ApperbackWeb.PageController do
  alias Apperback.Project
  alias Apperback.Project.Page
  alias ApperbackWeb.ErrorResponse

  use ApperbackWeb, :controller

  plug ApperbackWeb.Plugs.SetProject

  def create(%{assigns: %{project: %Project{id: project_id}}} = conn, %{"page" => page}) do
    %Project{} = project = Page.create(project_id, page)
    json(conn, %{project: project})
  end

  def update(%{assigns: %{project: %Project{id: project_id}}} = conn, %{
        "id" => id,
        "page" => page
      }) do
    %Project{} = project = Page.update(%Page{id: id}, project_id, page)
    json(conn, %{project: project})
  end
end
