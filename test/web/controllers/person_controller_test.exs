defmodule Timerobot.Web.PersonControllerTest do
  use Timerobot.Web.ConnCase

  alias Timerobot.Timesheet

  @create_attrs %{"name" => "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, slug: nil}

  def fixture(:person) do
    {:ok, person} = Timesheet.create_person(@create_attrs)
    person
  end

  test "lists all entries on index", %{conn: conn} do
    conn =
      conn
      |> login
      |> get(person_path(conn, :index))
    assert html_response(conn, 200) =~ "People"
  end

  test "renders form for new person", %{conn: conn} do
    conn =
      conn
      |> login
      |> get(person_path(conn, :new))
    assert html_response(conn, 200) =~ "New Person"
  end

  test "creates person and redirects to show when data is valid", %{conn: conn} do
    conn =
      conn
      |> login
      |> post(person_path(conn, :create), person: @create_attrs)

    assert %{slug: slug} = redirected_params(conn)
    assert redirected_to(conn) == person_path(conn, :show, slug)

    conn =
      build_conn()
      |> login
      |> get(person_path(conn, :show, slug))
    assert html_response(conn, 200) =~ @create_attrs["name"]
  end

  test "does not create person and renders errors when data is invalid", %{conn: conn} do
    conn =
      conn
      |> login
      |> post(person_path(conn, :create), person: @invalid_attrs)
    assert html_response(conn, 200) =~ "New Person"
  end

  test "renders form for editing chosen person", %{conn: conn} do
    person = fixture(:person)
    conn =
      conn
      |> login
      |> get(person_path(conn, :edit, person.slug))
    assert html_response(conn, 200) =~ "Edit Person"
  end

  test "updates chosen person and redirects when data is valid", %{conn: conn} do
    person = fixture(:person)
    conn =
      conn
      |> login
      |> put(person_path(conn, :update, person.slug), person: @update_attrs)
    assert redirected_to(conn) == person_path(conn, :show, person.slug)

    conn =
      build_conn()
      |> login
      |> get(person_path(conn, :show, person.slug))
    assert html_response(conn, 200) =~ "some updated name"
  end

  test "does not update chosen person and renders errors when data is invalid", %{conn: conn} do
    person = fixture(:person)
    conn =
      conn
      |> login
      |> put(person_path(conn, :update, person.slug), person: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit Person"
  end

  test "deletes chosen person", %{conn: conn} do
    person = fixture(:person)
    conn = conn |> login |> delete(person_path(conn, :delete, person.slug))
    assert redirected_to(conn) == person_path(conn, :index)
    assert_raise Ecto.NoResultsError, fn ->
      build_conn()
      |> login
      |> get(person_path(conn, :show, person.slug))
    end
  end
end
