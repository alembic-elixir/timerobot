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

  scope "/", Timerobot.Web do
    pipe_through :browser
    pipe_through :admin

    get "/", PageController, :index
    resources "/clients", ClientController
    resources "/projects", ProjectController
    resources "/people", PersonController
    resources "/times", EntryController
    get "/client-hours-repor", ClientHoursReportController, :index
  end
end
