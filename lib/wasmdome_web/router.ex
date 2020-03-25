defmodule WasmdomeWeb.Router do
  use WasmdomeWeb, :router

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

  scope "/auth", WasmdomeWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request 
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", WasmdomeWeb do
    pipe_through :browser    

    get "/", PageController, :index
    get "/logout", AuthController, :logout
    get "/leaderboard", LeaderboardController, :index
    get "/mechs", MechsController, :index
    
    get "/profile", ProfileController, :index
    get "/profile/edit", ProfileController, :edit
    put "/profile", ProfileController, :update

    get "/dashboard", DashboardController, :index

    get "/replay/:match_id/:turn", ReplayController, :index
    live "/matches/:match_id", NatLive
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", WasmdomeWeb do
  #   pipe_through :api
  # end
end
