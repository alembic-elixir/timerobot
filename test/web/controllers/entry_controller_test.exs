defmodule Timerobot.Web.EntryControllerTest do
  use Timerobot.Web.ConnCase

  alias Timerobot.Timesheet

  @create_attrs %{date: ~D[2010-04-17], hours: 42}
  @update_attrs %{date: ~D[2011-05-18], hours: 43}
  @invalid_attrs %{date: nil, hours: nil, person_id: nil, project_id: nil}

  setup do
    {:ok, _person} = Timesheet.create_person(%{"name" => "person", "password" => "password"})
    {:ok, client} = Timesheet.create_client(%{"name" => "client"})
    {:ok, _project} = Timesheet.create_project(%{"name" => "project", "client_id" => client.id})
    :ok
  end

  def fixture(:entry) do
    {:ok, entry} = @create_attrs
    |> Map.put(:person_id, hd(Timesheet.list_person).id)
    |> Map.put(:project_id, hd(Timesheet.all_projects).id)
    |> Timesheet.create_entry
    entry
  end

  test "lists all entries on index", %{conn: conn} do
    conn =
      conn
      |> login
      |> get(entry_path(conn, :index))
    assert html_response(conn, 200) =~ "Entries"
  end

  test "show an entry", %{conn: conn} do
    id = fixture(:entry).id
    entry = Timesheet.get_entry!(id)
    conn =
      conn
      |> login
      |> get(entry_path(conn, :show, entry.id))

    assert html_response(conn, 200) =~ entry.project.name
  end

  test "renders form for new entry", %{conn: conn} do
    conn =
      conn
      |> login
      |> get(entry_path(conn, :new))
    assert html_response(conn, 200) =~ "New Entry"
  end

  test "creates entry and redirects to show when data is valid", %{conn: conn} do
    person = Timesheet.list_person |> List.first
    project = Timesheet.all_projects |> List.first
    create_attrs =
      @create_attrs
      |> Map.put(:person_id, person.id)
      |> Map.put(:project_id, project.id)

    conn =
      conn
      |> login
      |> post(entry_path(conn, :create), entry: create_attrs)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == entry_path(conn, :show, id)

    conn =
      build_conn()
      |> login
      |> get(entry_path(conn, :show, id))
    assert html_response(conn, 200) =~ project.name
  end

  test "does not create entry and renders errors when data is invalid", %{conn: conn} do
    conn =
      conn
      |> login
      |> post(entry_path(conn, :create), entry: @invalid_attrs)
    assert html_response(conn, 200) =~ "New Entry"
  end

  test "renders form for editing chosen entry", %{conn: conn} do
    entry = fixture(:entry)
    conn =
      conn
      |> login
      |> get(entry_path(conn, :edit, entry))
    assert html_response(conn, 200) =~ "Edit Entry"
  end

  test "updates chosen entry and redirects when data is valid", %{conn: conn} do
    entry = fixture(:entry)
    conn =
      conn
      |> login
      |> put(entry_path(conn, :update, entry), entry: @update_attrs)
    assert redirected_to(conn) == entry_path(conn, :show, entry)
  end

  test "does not update chosen entry and renders errors when data is invalid", %{conn: conn} do
    entry = fixture(:entry)
    conn =
      conn
      |> login
      |> put(entry_path(conn, :update, entry), entry: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit Entry"
  end

  test "deletes chosen entry", %{conn: conn} do
    entry = fixture(:entry)
    conn = conn |> login |> delete(entry_path(conn, :delete, entry))
    assert redirected_to(conn) == entry_path(conn, :index)
    assert_raise Ecto.NoResultsError, fn ->
      build_conn()
      |> login
      |> get(entry_path(conn, :show, entry))
    end
  end
end
