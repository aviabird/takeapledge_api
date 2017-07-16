defmodule TakeaplegeApi.Web.SessionView do
  use TakeaplegeApi.Web, :view
  alias TakeaplegeApi.Web.SessionView
  
  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      token: session.token}
  end

  def render("error.json", _anything) do
    %{errors: "username/password is invalid"}
  end

  def render("forbidden.json", _anything) do
    %{errors: "Not Authorized"}
  end
end
