defmodule Timerobot.Web.EntryControllerTest do
  use Timerobot.Web.ConnCase

  alias Timerobot.Timesheet

  @create_attrs %{date: ~D[2010-04-17], hours: 42}
  @update_attrs %{date: ~D[2011-05-18], hours: 43}
  @invalid_attrs %{date: nil, hours: nil}

  def fixture(:entry) do
    {:ok, entry} = Timesheet.create_entry(@create_attrs)
    entry
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, entry_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Entry"
  end

  test "renders form for new entry", %{conn: conn} do
    conn = get conn, entry_path(conn, :new)
    assert html_response(conn, 200) =~ "New Entry"
  end

  test "creates entry and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, entry_path(conn, :create), entry: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == entry_path(conn, :show, id)

    conn = get conn, entry_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Entry"
  end

  test "does not create entry and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, entry_path(conn, :create), entry: @invalid_attrs
    assert html_response(conn, 200) =~ "New Entry"
  end

  test "renders form for editing chosen entry", %{conn: conn} do
    entry = fixture(:entry)
    conn = get conn, entry_path(conn, :edit, entry)
    assert html_response(conn, 200) =~ "Edit Entry"
  end

  test "updates chosen entry and redirects when data is valid", %{conn: conn} do
    entry = fixture(:entry)
    conn = put conn, entry_path(conn, :update, entry), entry: @update_attrs
    assert redirected_to(conn) == entry_path(conn, :show, entry)

    conn = get conn, entry_path(conn, :show, entry)
    assert html_response(conn, 200)
  end

  test "does not update chosen entry and renders errors when data is invalid", %{conn: conn} do
    entry = fixture(:entry)
    conn = put conn, entry_path(conn, :update, entry), entry: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Entry"
  end

  test "deletes chosen entry", %{conn: conn} do
    entry = fixture(:entry)
    conn = delete conn, entry_path(conn, :delete, entry)
    assert redirected_to(conn) == entry_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, entry_path(conn, :show, entry)
    end
  end
end
