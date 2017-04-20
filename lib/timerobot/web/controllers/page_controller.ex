defmodule Timerobot.Web.PageController do
  use Timerobot.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
