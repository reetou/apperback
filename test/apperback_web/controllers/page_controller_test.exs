defmodule ApperbackWeb.PageControllerTest do
  use ApperbackWeb.ConnCase
  import ApperbackWeb.ProjectTestHelpers
  import ApperbackWeb.AuthTestHelpers
  alias Apperback.Project

  @moduletag :page

  defp validate_project(project) do
    assert is_map(project)
    assert is_binary(project["id"])
    assert is_binary(project["project_name"])
    assert is_list(project["pages"])
  end

  defp validate_component_child(child, id) do
    assert is_binary(id)
    assert not is_nil(child)
    assert child["id"] !== id
    assert is_binary(child["id"])
  end

  defp create_child(id, data) do
    Map.merge(data, %{"id" => id})
  end

  describe "Create page" do
    setup [:setup_user_conn, :create_project]

    test "Should create new page successfully", %{conn: conn, project: %{id: project_id}} do
      client_id = "#{DateTime.utc_now()}"
      name = "Some name1 #{DateTime.utc_now()}"

      conn =
        post(conn, Routes.page_path(conn, :create, project_id), %{
          "page" => %{
            "id" => client_id,
            "name" => name
          }
        })

      project = json_response(conn, 200)["project"]
      validate_project(project)
      assert length(project["pages"]) == 2

      page =
        Enum.find(project["pages"], fn %{"name" => page_name} ->
          name == page_name
        end)

      assert not is_nil(page)
      assert page["id"] != client_id
      assert is_binary(page["id"])
    end

    test "Should create new page with custom components successfully", %{
      conn: conn,
      project: %{id: project_id}
    } do
      name = "Some name #{DateTime.utc_now()}"
      component_id = "componentid#{DateTime.utc_now()}"
      component_type = "custom_input"

      props = %{
        "text" => "Some text"
      }

      component = %{
        "id" => component_id,
        "children" => [],
        "item_type" => component_type,
        "props" => props
      }

      child1 =
        create_child("child1", %{
          "children" => [],
          "item_type" => component_type,
          "props" => props
        })

      child2 =
        create_child("child2", %{
          "children" => [],
          "item_type" => component_type,
          "props" => props
        })

      components = [
        %{
          "id" => component_id,
          "children" => [
            child1,
            child2
          ],
          "item_type" => component_type,
          "props" => props
        }
      ]

      conn =
        post(conn, Routes.page_path(conn, :create, project_id), %{
          "page" => %{
            "name" => name,
            "components" => components
          }
        })

      project = json_response(conn, 200)["project"]
      validate_project(project)
      assert length(project["pages"]) == 2

      page =
        Enum.find(project["pages"], fn %{"name" => page_name} ->
          name == page_name
        end)

      assert not is_nil(page)
      assert is_binary(page["id"])

      component =
        Enum.find(page["components"], fn %{"item_type" => item_type} ->
          item_type == component_type
        end)

      assert not is_nil(component)
      assert component["id"] !== component_id
      assert is_binary(component["id"])
      assert component["props"]["text"] == props["text"]

      validate_component_child(Enum.at(component["children"], 0), child1["id"])

      validate_component_child(Enum.at(component["children"], 1), child2["id"])
    end

    test "Should send error if user does not own selected project", %{
      conn: conn,
      user: %{id: user_id}
    } do
      %Project{id: id, user_id: project_user_id} =
        Project.create_default_project("45#{DateTime.utc_now()}")

      assert project_user_id != user_id

      conn =
        post(conn, Routes.page_path(conn, :create, id), %{
          "page" => %{
            "name" => "other_name"
          }
        })

      assert json_response(conn, 404)
    end
  end

  describe "Update page" do
    setup [:setup_user_conn, :create_project]

    test "Should update page successfully", %{
      conn: conn,
      project: %{id: project_id, pages: [old_page | tail]}
    } do
      client_id = "#{DateTime.utc_now()}"
      name = "Page updated #{DateTime.utc_now()}"

      conn =
        put(conn, Routes.page_path(conn, :update, project_id, old_page.id), %{
          "page" => %{
            "id" => client_id,
            "name" => name
          }
        })

      project = json_response(conn, 200)["project"]
      validate_project(project)
      assert length(project["pages"]) == 1

      page =
        Enum.find(project["pages"], fn %{"id" => page_id} ->
          page_id == old_page.id
        end)

      assert not is_nil(page)
      assert page["name"] == name
      assert is_binary(page["id"])
    end

    test "Should update page with custom components successfully", %{
      conn: conn,
      project: %{id: project_id, pages: [old_page | tail]}
    } do
      name = "Some name #{DateTime.utc_now()}"
      component_id = "componentid#{DateTime.utc_now()}"
      component_type = "custom_input"

      props = %{
        "text" => "Some text"
      }

      component = %{
        "id" => component_id,
        "children" => [],
        "item_type" => component_type,
        "props" => props
      }

      child1 =
        create_child("child1", %{
          "children" => [],
          "item_type" => component_type,
          "props" => props
        })

      child2 =
        create_child("child2", %{
          "children" => [],
          "item_type" => component_type,
          "props" => props
        })

      components = [
        %{
          "id" => component_id,
          "children" => [
            child1,
            child2
          ],
          "item_type" => component_type,
          "props" => props
        }
      ]

      conn =
        put(conn, Routes.page_path(conn, :update, project_id, old_page.id), %{
          "page" => %{
            "name" => name,
            "components" => components
          }
        })

      project = json_response(conn, 200)["project"]
      validate_project(project)
      assert length(project["pages"]) == 1

      page =
        Enum.find(project["pages"], fn %{"id" => page_id} ->
          page_id == old_page.id
        end)

      assert not is_nil(page)
      assert page["name"] == name
      assert is_binary(page["id"])

      component =
        Enum.find(page["components"], fn %{"item_type" => item_type} ->
          item_type == component_type
        end)

      assert not is_nil(component)
      assert component["id"] !== component_id
      assert is_binary(component["id"])
      assert component["props"]["text"] == props["text"]

      validate_component_child(Enum.at(component["children"], 0), child1["id"])

      validate_component_child(Enum.at(component["children"], 1), child2["id"])
    end

    test "Should send error if user does not own selected project", %{
      conn: conn,
      user: %{id: user_id}
    } do
      %Project{id: id, user_id: project_user_id, pages: [page | tail]} =
        Project.create_default_project("45#{DateTime.utc_now()}")

      assert project_user_id != user_id

      conn =
        put(conn, Routes.page_path(conn, :update, id, page.id), %{
          "page" => %{
            "name" => "some name"
          }
        })

      assert json_response(conn, 404)
    end
  end
end
