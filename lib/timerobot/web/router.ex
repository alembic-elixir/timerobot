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

  pipeline :admin do
    plug BasicAuth, use_config: {:timerobot, :basic_auth}
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Timerobot.CurrentUser
  end

  scope "/", Timerobot.Web do
    pipe_through [:browser, :with_session]
    pipe_through :admin

    get "/", PageController, :index

    resources "/clients", ClientController, param: "slug"
    resources "/projects", ProjectController, param: "slug"
    resources "/people", PersonController, param: "slug"
    resources "/times", EntryController

    resources "/session", SessionController, only: [:new, :create, :delete]

    get "/report", ReportController, :report
  end
end
