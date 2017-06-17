defmodule TakeaplegeApi.Web.Router do
  use TakeaplegeApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TakeaplegeApi.Web do
    pipe_through :api
  end
end
