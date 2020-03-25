defmodule WasmdomeWeb.Router do
  use WasmdomeWeb, :router
  import WasmdomeWeb.Auth , only: [authenticate: 2, allow_anonymous: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {WasmdomeWeb.LayoutView, :root}
  end

  pipeline :secure do    
    plug :authenticate
  end

  pipeline :anonymous_allowed do
    plug :allow_anonymous
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
    pipe_through [:browser, :anonymous_allowed]

    get "/",                        PageController, :index
    get "/logout",                  AuthController, :logout    
    
    get "/leaderboard",             LeaderboardController, :index
    
    get "/history",                 HistoryController, :index
    get "/replay/:match_id/:turn",  ReplayController, :index

    #live "/matches/:match_id", NatLive
    #live "/dashboard", DashboardLive, :index

  end

  scope "/my", WasmdomeWeb do
    pipe_through [:browser, :secure]

    get "/profile", ProfileController, :index
    get "/profile/edit", ProfileController, :edit
    put "/profile", ProfileController, :update
    get "/mechs", MechsController, :index

  end

  scope "/dashboard", WasmdomeWeb do
    pipe_through [:browser, :secure]

    live "/", DashboardLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WasmdomeWeb do
  #   pipe_through :api
  # end
end
