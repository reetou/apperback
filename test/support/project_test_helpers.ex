defmodule ApperbackWeb.ProjectTestHelpers do
  alias ApperbackWeb.Factories.ProjectFactory
  alias Apperback.Project

  def create_project(ctx) do
    Map.put(ctx, :project, ProjectFactory.create_project())
  end

  def ensure_project_exists(%{project: %{id: id}} = ctx) do
    %Project{id: ^id} = Project.get(id)
    ctx
  end
end