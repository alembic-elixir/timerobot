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
    resources "/clients", ClientController
    resources "/projects", ProjectController
    resources "/people", PersonController
    resources "/times", EntryController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Timerobot.Web do
  #   pipe_through :api
  # end
end
