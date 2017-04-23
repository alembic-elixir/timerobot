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

  scope "/", Timerobot.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/client", ClientController
    resources "/project", ProjectController
    resources "/person", PersonController
    resources "/entry", EntryController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Timerobot.Web do
  #   pipe_through :api
  # end
end
