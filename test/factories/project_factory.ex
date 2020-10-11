defmodule ApperbackWeb.Factories.ProjectFactory do
  use ExMachina
  alias Apperback.Project
  alias Apperback.Project.Page

  def project_factory(attrs \\ %{}) do
    %Project{
      id: Ecto.UUID.generate(),
      pages: List.wrap(Page.default_page()),
      project_name: sequence("project_name")
    }
    |> merge_attributes(attrs)
  end

  def create_project(user_id) do
    %Project{} = Project.create_default_project(user_id)
  end
end
