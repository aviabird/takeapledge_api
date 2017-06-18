defmodule TakeaplegeApi.Web.SessionControllerTest do
  use TakeaplegeApi.Web.ConnCase

  alias TakeaplegeApi.App

  @valid_attrs %{
    email: "test@aviabird.com", password: "s3cr3t",
    name: "Test", bio: "Test"}

  setup %{conn: conn} do
    {:ok, _} = App.create_user(@valid_attrs)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    token = json_response(conn, 201)["data"]["token"]
    assert App.get_session_by_token!(token)
  end

  test "does not create resource and renders errors when password is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: Map.put(@valid_attrs, :password, "notright")
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and renders errors when email is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: Map.put(@valid_attrs, :email, "not@found.com")
    assert json_response(conn, 422)["errors"] != %{}
  end
end
