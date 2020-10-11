defmodule ApperbackWeb.ProjectTestHelpers do
  alias ApperbackWeb.Factories.ProjectFactory
  alias Apperback.Project

  def create_project(%{user: %{id: user_id}} = ctx) do
    Map.put(ctx, :project, ProjectFactory.create_project(user_id))
  end

  def ensure_project_exists(%{project: %{id: id}} = ctx) do
    %Project{id: ^id} = Project.get(id)
    ctx
  end
end
