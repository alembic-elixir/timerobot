defmodule Timerobot.GuardianErrorHandler do
  alias Timerobot.Web.Router.Helpers, as: Routes

  def unauthenticated(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(:error, "You must sign in to access this page")
    |> Phoenix.Controller.redirect(to: Routes.session_path(conn, :new))
  end

end
