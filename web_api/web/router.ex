defmodule WebApi.Router do
  use WebApi.Web, :router

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

  scope "/", WebApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/accounts", AccountController, except: [:new, :edit]
    resources "/widgets", WidgetController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebApi do
  #   pipe_through :api
  # end
end
