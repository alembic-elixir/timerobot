defmodule Timerobot.Web.SessionController do
  use Timerobot.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Timerobot.Timesheet.Person
  alias Timerobot.Repo

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" =>
                      %{"name" => name,
                        "password" => password }}) do
    user = Repo.get_by(Person, name: name)
    password = password || ""

    result = cond do
      user && checkpw(password, user.encrypted_password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true -> dummy_checkpw()
        {:error, :not_found, conn}
    end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "you are now logged in")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid login or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "Goodbye")
    |> redirect(to: page_path(conn, :index))
  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end
