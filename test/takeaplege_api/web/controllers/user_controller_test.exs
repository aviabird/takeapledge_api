defmodule TakeaplegeApi.Web.UserControllerTest do
  use TakeaplegeApi.Web.ConnCase

  alias TakeaplegeApi.App
  alias TakeaplegeApi.App.User
  alias TakeaplegeApi.Repo

  @create_attrs %{
    email: "new_user@aviabird.com",
    password: "newpass",
    name: "New User",
    bio: "Software Developer"
  }
  @update_attrs %{
    email: "updated_user@aviabird.com",
    password: "updatepass",
    name: "Updated User",
    bio: "Senior Software Developer"
  }
  @invalid_attrs %{email: nil, password: nil, name: nil, bio: nil}

  def fixture(:user) do
    {:ok, user} = App.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, user_path(conn, :show, id)
    body = json_response(conn, 200)
    assert body["data"] == %{
      "id" => id,
      "email" => "new_user@aviabird.com",
      "name" => "New User",
      "bio" => "Software Developer"}

    refute body["data"]["password"]
    assert Repo.get_by(User, email: "new_user@aviabird.com")
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen user and renders user when data is valid", %{conn: conn} do
    %User{id: id} = user = fixture(:user)
    conn = put conn, user_path(conn, :update, user), user: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "email" => "updated_user@aviabird.com",
      "name" => "Updated User",
      "bio" => "Senior Software Developer"}
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
    user = fixture(:user)
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen user", %{conn: conn} do
    user = fixture(:user)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, user)
    end
  end
end
