defmodule Timerobot.Web.PageControllerTest do
  use Timerobot.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn =
  conn
  |> using_basic_auth
  |> get("/")
    assert html_response(conn, 200) =~ "Welcome to Timerobot"
  end
end
