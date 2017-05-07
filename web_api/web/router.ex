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
    pipe_through :api # Use the default browser stack

    get "/", PageController, :index
    resources "/accounts", AccountController, except: [:new, :edit]
    post "/accounts/transfer_widgets", AccountController, :transfer_widgets

    resources "/widgets", WidgetController, except: [:new, :edit]
    get "/widgets/account_widgets/:account_id", WidgetController, :account_widgets
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebApi do
  #   pipe_through :api
  # end
end
