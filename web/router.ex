defmodule UaArchaeology.Router do
  use UaArchaeology.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug UaArchaeology.CurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UaArchaeology do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/finds", FindController, only: [:index, :show]

    resources "/users", UserController do
      resources "/finds", FindController
    end

    resources "/users", UserController do
      resources "/cultures", CultureController
    end
    resources "/users", UserController do
      resources "/object_types", ObjectTypeController
    end
    resources "/users", UserController do
      resources "/site_types", SiteTypeController
    end
    resources "/users", UserController do
      resources "/research_levels", ResearchLevelController
    end
    resources "/users", UserController do
      resources "/conditions", ConditionController
    end
    resources "/users", UserController do
      resources "/authors", AuthorController
    end
    resources "/users", UserController do
      resources "/publications", PublicationController
    end
    resources "/users", UserController do
      resources "/natural_researches", NaturalResearchController
    end
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", UaArchaeology do
  #   pipe_through :api
  # end
end
