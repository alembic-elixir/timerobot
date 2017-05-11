defmodule Timerobot.Web.PersonControllerTest do
  use Timerobot.Web.ConnCase

  alias Timerobot.Timesheet

  @create_attrs %{"name" => "some name"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  def fixture(:person) do
    {:ok, person} = Timesheet.create_person(@create_attrs)
    person
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, person_path(conn, :index)
    assert html_response(conn, 200) =~ "People"
  end

  test "renders form for new person", %{conn: conn} do
    conn = get conn, person_path(conn, :new)
    assert html_response(conn, 200) =~ "New Person"
  end

  test "creates person and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, person_path(conn, :create), person: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == person_path(conn, :show, id)

    conn = get conn, person_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Person"
  end

  test "does not create person and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, person_path(conn, :create), person: @invalid_attrs
    assert html_response(conn, 200) =~ "New Person"
  end

  test "renders form for editing chosen person", %{conn: conn} do
    person = fixture(:person)
    conn = get conn, person_path(conn, :edit, person)
    assert html_response(conn, 200) =~ "Edit Person"
  end

  test "updates chosen person and redirects when data is valid", %{conn: conn} do
    person = fixture(:person)
    conn = put conn, person_path(conn, :update, person), person: @update_attrs
    assert redirected_to(conn) == person_path(conn, :show, person)

    conn = get conn, person_path(conn, :show, person)
    assert html_response(conn, 200) =~ "some updated name"
  end

  test "does not update chosen person and renders errors when data is invalid", %{conn: conn} do
    person = fixture(:person)
    conn = put conn, person_path(conn, :update, person), person: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Person"
  end

  test "deletes chosen person", %{conn: conn} do
    person = fixture(:person)
    conn = delete conn, person_path(conn, :delete, person)
    assert redirected_to(conn) == person_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, person_path(conn, :show, person)
    end
  end
end
