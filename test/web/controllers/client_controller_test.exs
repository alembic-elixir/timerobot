defmodule Timerobot.Web.ClientControllerTest do
  use Timerobot.Web.ConnCase

  alias Timerobot.Timesheet

  @create_attrs %{"name" => "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, slug: nil}

  def fixture(:client) do
    {:ok, client} = Timesheet.create_client(@create_attrs)
    client
  end

  test "lists all entries on index", %{conn: conn} do
    conn =
      conn
      |> login
      |> get(client_path(conn, :index))
    assert html_response(conn, 200) =~ "Clients"
  end

  test "renders form for new client", %{conn: conn} do
    conn =
      conn
      |> login
      |> get(client_path(conn, :new))
    assert html_response(conn, 200) =~ "New Client"
  end

  test "creates client and redirects to show when data is valid", %{conn: conn} do
    conn =
      conn
      |> login
      |> post(client_path(conn, :create), client: @create_attrs)

    assert %{slug: slug} = redirected_params(conn)
    assert redirected_to(conn) == client_path(conn, :show, slug)

    conn =
      build_conn()
      |> login
      |> get(client_path(conn, :show, slug))
    assert html_response(conn, 200) =~ "some name"
  end

  test "does not create client and renders errors when data is invalid", %{conn: conn} do
    conn =
      conn
      |> login
      |> post(client_path(conn, :create), client: @invalid_attrs)
    assert html_response(conn, 200) =~ "New Client"
  end

  test "renders form for editing chosen client", %{conn: conn} do
    client = fixture(:client)
    conn =
      conn
      |> login
      |> get(client_path(conn, :edit, client.slug))
    assert html_response(conn, 200) =~ "Edit Client"
  end

  test "updates chosen client and redirects when data is valid", %{conn: conn} do
    client = fixture(:client)
    conn =
      conn
      |> login
      |> put(client_path(conn, :update, client.slug), client: @update_attrs)
    assert redirected_to(conn) == client_path(conn, :show, client.slug)

    conn =
      build_conn()
      |> login
      |> get(client_path(conn, :show, client.slug))
    assert html_response(conn, 200) =~ "some updated name"
  end

  test "does not update chosen client and renders errors when data is invalid", %{conn: conn} do
    client = fixture(:client)
    conn =
      conn
      |> login
      |> put(client_path(conn, :update, client.slug), client: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit Client"
  end

  test "deletes chosen client", %{conn: conn} do
    client = fixture(:client)
    conn = conn |> login |> delete(client_path(conn, :delete, client.slug))
    assert redirected_to(conn) == client_path(conn, :index)
    assert_raise Ecto.NoResultsError, fn ->
      build_conn()
      |> login
      |> get(client_path(conn, :show, client.slug))
    end
  end
end
