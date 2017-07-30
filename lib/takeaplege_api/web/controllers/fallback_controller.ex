defmodule TakeaplegeApi.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TakeaplegeApi.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(TakeaplegeApi.Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(TakeaplegeApi.Web.ErrorView, :"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(TakeaplegeApi.Web.SessionView, "forbidden.json")
  end
  
  def call(conn, {:error, user_params}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("error.json", user_params)
  end
end
