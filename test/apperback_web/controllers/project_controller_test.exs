defmodule ApperbackWeb.ProjectControllerTest do
  use ApperbackWeb.ConnCase
  import ApperbackWeb.ProjectTestHelpers

  @moduletag :project

  describe "Get project by id" do

    setup [:create_project, :ensure_project_exists]

    test "Should get successfully", %{conn: conn, project: %{id: id}} do
      conn = get(conn, Routes.project_path(conn, :show, id))
      assert json_response(conn, 200)["project"]["id"] == id
    end

    test "Should send error if no project found", %{conn: conn} do
      conn = get(conn, Routes.project_path(conn, :show, "123"))
      assert json_response(conn, 404)
    end
  end

  describe "Create project" do

    test "Should create default project successfully", %{conn: conn} do
      conn = post(conn, Routes.project_path(conn, :create))
      project = json_response(conn, 200)["project"]
      assert is_map(project)
      assert is_binary(project["id"])
      assert is_binary(project["project_name"])
      assert is_list(project["pages"])
    end

    test "Should create project with custom data", %{conn: conn} do
      client_id = "456"
      conn = post(conn, Routes.project_path(conn, :create), %{
        "project" => %{
          "id" => client_id,
          "project_name" => "project_name",
          "pages" => []
        }
      })
      project = json_response(conn, 200)["project"]
      assert is_map(project)
      assert is_binary(project["id"])
      assert project["id"] != client_id
      assert is_binary(project["project_name"])
      assert is_list(project["pages"])
    end
  end

  describe "Update project" do
    setup [:create_project, :ensure_project_exists]

    test "Should update successfully", %{conn: conn, project: %{id: id}} do
      name = "#{DateTime.utc_now()}_project"
      conn = put(conn, Routes.project_path(conn, :update, id), %{
        "project" => %{
          "project_name" => name
        }
      })
      project = json_response(conn, 200)["project"]
      assert is_map(project)
      assert is_binary(project["id"])
      assert project["id"] == id
      assert is_binary(project["project_name"])
      assert project["project_name"] == name
      assert is_list(project["pages"])
    end

    test "Should not update id", %{conn: conn, project: %{id: id}} do
      client_id = "123"
      conn = put(conn, Routes.project_path(conn, :update, id), %{
        "project" => %{
          "id" => client_id,
        }
      })
      project = json_response(conn, 200)["project"]
      assert is_map(project)
      assert is_binary(project["id"])
      assert project["id"] != client_id
      assert is_binary(project["project_name"])
      assert is_list(project["pages"])
    end
  end
end
