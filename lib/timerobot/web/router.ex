defmodule Timerobot.Web.Router do
  use Timerobot.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
        handler: Timerobot.GuardianErrorHandler
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Timerobot.CurrentUser
  end

  scope "/", Timerobot.Web do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index

    resources "/session", SessionController, only: [:new, :create, :delete]

    scope "/" do
      pipe_through :login_required

      resources "/people", PersonController, param: "slug"
      resources "/clients", ClientController, param: "slug"
      resources "/projects", ProjectController, param: "slug"
      resources "/times", EntryController

      get "/report", ReportController, :report
    end
  end
end
