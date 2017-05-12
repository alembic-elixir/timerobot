defmodule Timerobot.Web.ClientControllerTest do
  use Timerobot.Web.ConnCase

  alias Timerobot.Timesheet

  @create_attrs %{"name" => "some name"}
  @update_attrs %{name: "some updated name", slug: "some-updated-name"}
  @invalid_attrs %{name: nil, slug: nil}

  def fixture(:client) do
    {:ok, client} = Timesheet.create_client(@create_attrs)
    client
  end

  test "lists all entries on index", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth
      |> get(client_path(conn, :index))
    assert html_response(conn, 200) =~ "Clients"
  end

  test "renders form for new client", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth
      |> get(client_path(conn, :new))
    assert html_response(conn, 200) =~ "New Client"
  end

  test "creates client and redirects to show when data is valid", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth
      |> post(client_path(conn, :create), client: @create_attrs)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == client_path(conn, :show, id)

    conn =
      build_conn()
      |> using_basic_auth
      |> get(client_path(conn, :show, id))
    assert html_response(conn, 200) =~ "some name"
  end

  test "does not create client and renders errors when data is invalid", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth
      |> post(client_path(conn, :create), client: @invalid_attrs)
    assert html_response(conn, 200) =~ "New Client"
  end

  test "renders form for editing chosen client", %{conn: conn} do
    client = fixture(:client)
    conn =
      conn
      |> using_basic_auth
      |> get(client_path(conn, :edit, client))
    assert html_response(conn, 200) =~ "Edit Client"
  end

  test "updates chosen client and redirects when data is valid", %{conn: conn} do
    client = fixture(:client)
    conn =
      conn
      |> using_basic_auth
      |> put(client_path(conn, :update, client), client: @update_attrs)
    assert redirected_to(conn) == client_path(conn, :show, client)

    conn =
      build_conn()
      |> using_basic_auth
      |> get(client_path(conn, :show, client))
    assert html_response(conn, 200) =~ "some updated name"
  end

  test "does not update chosen client and renders errors when data is invalid", %{conn: conn} do
    client = fixture(:client)
    conn =
      conn
      |> using_basic_auth
      |> put(client_path(conn, :update, client), client: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit Client"
  end

  test "deletes chosen client", %{conn: conn} do
    client = fixture(:client)
    conn = conn |> using_basic_auth |> delete(client_path(conn, :delete, client))
    assert redirected_to(conn) == client_path(conn, :index)
    assert_error_sent 404, fn ->
      build_conn()
      |> using_basic_auth
      |> get(client_path(conn, :show, client))
    end
  end
end
