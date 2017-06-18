defmodule TakeaplegeApi.Web.SessionController do
  use TakeaplegeApi.Web, :controller

  alias TakeaplegeApi.App
  alias TakeaplegeApi.App.Session

  action_fallback TakeaplegeApi.Web.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %Session{} = session} <- App.create_session(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    end
  end

end
