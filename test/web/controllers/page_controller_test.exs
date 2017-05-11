defmodule Timerobot.Web.PageControllerTest do
  use Timerobot.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Timerobot"
  end
end
