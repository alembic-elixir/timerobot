defmodule Timerobot.Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import Timerobot.Web.Router.Helpers

      # The default endpoint for testing
      @endpoint Timerobot.Web.Endpoint

      defp login(conn, username \\ "admin", password \\ "s3cr1t") do
        person = find_or_create_person(username, password)

        conn
        |> post(
          session_path(conn, :create), session: %{
            name: username, password: password
          })
        |> recycle()
      end

      defp find_or_create_person(username, password) do
        person = Timerobot.Repo.get_by(Timerobot.Timesheet.Person, name: username)

        if person do
          person
        else
          Timerobot.Timesheet.create_person %{
            "name" => username,
            "password" => password
          }
        end
      end
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Timerobot.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Timerobot.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
