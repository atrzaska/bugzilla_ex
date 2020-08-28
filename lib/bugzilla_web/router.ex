defmodule BugzillaWeb.Router do
  use BugzillaWeb, :router

  import BugzillaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug NavigationHistory.Tracker
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :empty_layout do
    plug :put_layout, {BugzillaWeb.LayoutView, :empty}
  end

  pipeline :auth_layout do
    plug :put_layout, {BugzillaWeb.LayoutView, :auth}
  end

  scope "/", BugzillaWeb do
    pipe_through [:browser, :empty_layout]

    get "/", ProductController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BugzillaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/admin/dashboard", metrics: BugzillaWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", BugzillaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :auth_layout]

    get "/signup", UserRegistrationController, :new
    post "/signup", UserRegistrationController, :create
    get "/signin", UserSessionController, :new
    post "/signin", UserSessionController, :create
    get "/recover", UserResetPasswordController, :new
    post "/recover", UserResetPasswordController, :create
    get "/recover/success", UserResetPasswordSuccessController, :index
    get "/signup/success", UserRegistrationSuccessController, :index
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", BugzillaWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/projects", ProjectController, except: [:show] do
      resources "/people", PeopleController, except: [:show]

      get "/current", StoryController, :current
      get "/backlog", StoryController, :backlog
      get "/icebox", StoryController, :icebox
      get "/done", StoryController, :done

      resources "/stories", StoryController
    end

    resources "/tasks", TaskController
    resources "/comments", CommentController

    get "/dashboard", DashboardController, :index
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", BugzillaWeb do
    pipe_through [:browser, :empty_layout]

    get "/privacy", PrivacyController, :index
    get "/terms", TermsController, :index
  end

  scope "/", BugzillaWeb do
    pipe_through [:browser, :auth_layout]

    delete "/logout", UserSessionController, :delete
    get "/confirm", UserConfirmationController, :new
    post "/confirm", UserConfirmationController, :create
    get "/confirm/:token", UserConfirmationController, :confirm
  end
end
