defmodule ApperbackWeb.Plugs.SetProject do
  import Plug.Conn

  alias Apperback.Project
  require Logger

  def init(default), do: default

  def call(
        %Plug.Conn{assigns: %{current_user: %{id: id}}, params: %{"project_id" => project_id}} =
          conn,
        _
      )
      when is_binary(project_id) do
    case Project.get_for_user(id, project_id) do
      nil ->
        assign(conn, :project, nil)

      %Project{id: ^project_id, user_id: ^id} = project ->
        assign(conn, :project, project)

      {:error, _} = error ->
        Logger.error(
          "Cannot assign project for user id #{id} and project id #{project_id}: #{inspect(error)}"
        )

        assign(conn, :project, :error)
    end
  end

  def call(conn, _) do
    assign(conn, :project, nil)
  end
end
