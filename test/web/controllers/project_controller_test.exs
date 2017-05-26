defmodule Timerobot.Web.ProjectControllerTest do
  use Timerobot.Web.ConnCase

  alias Timerobot.Timesheet

  @create_attrs %{"name" => "some name", "person_id" => 1, "project_id" => 1}
  @update_attrs %{"name" => "some updated name", "person_id" => 1, "project_id" => 1}
  @invalid_attrs %{"name" => nil, "person_id" => nil, "project_id" => nil}

  setup do
    {:ok, _client} = Timesheet.create_client(%{"name" => "client"})
    :ok
  end

  def fixture(:project) do
    {:ok, project} = @create_attrs
    |>Map.put("client_id", hd(Timesheet.all_clients).id)
    |> Timesheet.create_project
    project
  end

  test "lists all entries on index", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth
      |> get(project_path(conn, :index))
    assert html_response(conn, 200) =~ "Projects"
  end

  test "renders form for new project", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth
      |> get(project_path(conn, :new))
    assert html_response(conn, 200) =~ "New Project"
  end

  test "creates project and redirects to show when data is valid", %{conn: conn} do
    create_attrs =
      @create_attrs
      |> Map.put(:client_id, hd(Timesheet.all_clients).id)

    conn =
      conn
      |> using_basic_auth
      |> post(project_path(conn, :create), project: create_attrs)

    assert %{slug: slug} = redirected_params(conn)
    assert redirected_to(conn) == project_path(conn, :show, slug)

    conn =
      build_conn()
      |> using_basic_auth
      |> get(project_path(conn, :show, slug))
    assert html_response(conn, 200) =~ "some name"
  end

  test "does not create project and renders errors when data is invalid", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth
      |> post(project_path(conn, :create), project: @invalid_attrs)
    assert html_response(conn, 200) =~ "New Project"
  end

  test "renders form for editing chosen project", %{conn: conn} do
    project = fixture(:project)
    conn =
      conn
      |> using_basic_auth
      |> get(project_path(conn, :edit, project.slug))
    assert html_response(conn, 200) =~ "Edit Project"
  end

  test "updates chosen project and redirects when data is valid", %{conn: conn} do
    project = fixture(:project)
    conn =
      conn
      |> using_basic_auth
      |> put(project_path(conn, :update, project.slug), project: @update_attrs)
    assert redirected_to(conn) == project_path(conn, :show, project.slug)

    conn =
      build_conn()
      |> using_basic_auth
      |> get(project_path(conn, :show, project.slug))
    assert html_response(conn, 200) =~ "some updated name"
  end

  test "does not update chosen project and renders errors when data is invalid", %{conn: conn} do
    project = fixture(:project)
    conn =
      conn
      |> using_basic_auth
      |> put(project_path(conn, :update, project.slug), project: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit Project"
  end

  test "deletes chosen project", %{conn: conn} do
    project = fixture(:project)
    conn = conn |> using_basic_auth |> delete(project_path(conn, :delete, project.slug))
    assert redirected_to(conn) == project_path(conn, :index)
    assert_error_sent 404, fn ->
      build_conn()
      |> using_basic_auth
      |> get(project_path(conn, :show, project.slug))
    end
  end
end
