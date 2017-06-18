defmodule TakeaplegeApi.Web.Router do
  use TakeaplegeApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TakeaplegeApi.Web do
    pipe_through :api
    
    resources "/categories", CategoryController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/sessions", SessionController, only: [:create]
  end
end
