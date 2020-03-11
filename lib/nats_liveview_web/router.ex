defmodule NatsLiveviewWeb.Router do
  use NatsLiveviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", NatsLiveviewWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request 
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", NatsLiveviewWeb do
    pipe_through :browser    

    get "/", PageController, :index
    live "/matches/:match_id", NatLive
    get "/logout", AuthController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", NatsLiveviewWeb do
  #   pipe_through :api
  # end
end
