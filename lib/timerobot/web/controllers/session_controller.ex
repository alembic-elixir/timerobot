defmodule Timerobot.Web.SessionController do
  use Timerobot.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" =>
                      %{"name" => name,
                        "password" => password }}) do

  end

  def delete(conn, _) do
    
  end
end
