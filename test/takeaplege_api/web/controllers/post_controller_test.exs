defmodule TakeaplegeApi.Web.PostControllerTest do
  use TakeaplegeApi.Web.ConnCase

  alias TakeaplegeApi.Category
  alias TakeaplegeApi.Category.Post
  alias TakeaplegeApi.App
  # alias TakeaplegeApi.Repo
  # alias TakeaplegeApi.App.User

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  @user_attrs %{
    email: "test@aviabird.com", password: "s3cr3t",
    name: "Test", bio: "Test"}
  @category_attrs %{desc: "some desc", title: "some title"}

  def fixture(:post, user \\ nil) do
    {:ok, user} = case user do
      nil -> App.create_user(@user_attrs)
      _ -> {:ok, user}
    end
    
    {:ok, category} = App.create_category(@category_attrs)
    {:ok, post} = Category.create_post(
      @create_attrs
      |> Map.put(:category_id, category.id)
      |> Map.put(:user_id, user.id)
    )
    post
  end

  setup %{conn: conn} do
    {:ok, user} = App.create_user(@user_attrs)
    {:ok, session} = App.create_session(%{
      "email" => "test@aviabird.com",
      "password" => "s3cr3t"})
    
    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token token=#{session.token}")
    {:ok, %{conn: conn, current_user: user}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates post and renders post when data is valid",
    %{conn: conn, current_user: current_user}
  do
    {:ok, category} = App.create_category(@category_attrs)
    conn = post conn, post_path(conn, :create),
      post: @create_attrs
            |> Map.put(:category_id, category.id)
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, post_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "content" => "some content",
      "title" => "some title",
      "category_id" => category.id,
      "user_id" => current_user.id}
  end

  test "does not create post and renders errors when data is invalid",
    %{conn: conn, current_user: _current_user}
  do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen post and renders post when data is valid",
    %{conn: conn, current_user: current_user}
  do
    %Post{id: id} = post = fixture(:post, current_user)
    conn = put conn, post_path(conn, :update, post),
      post: Map.put(@update_attrs, :user_id, current_user.id)
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, post_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "content" => "some updated content",
      "title" => "some updated title",
      "category_id" => post.category_id,
      "user_id" => current_user.id}
  end

  test "does not update chosen post and renders errors when data is invalid",
    %{conn: conn, current_user: current_user}
  do
    post = fixture(:post, current_user)
    conn = put conn, post_path(conn, :update, post),
      post: Map.put(@invalid_attrs, :user_id, current_user.id)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update post and renders errors when user is not valid",
    %{conn: conn, current_user: current_user}
  do
    %Post{id: id} = post = fixture(:post)
    conn = put conn, post_path(conn, :update, post),
      post: Map.put(@update_attrs, :user_id, post.user_id)
    assert json_response(conn, 401)["errors"] != %{}
  end

  test "deletes chosen post", %{conn: conn, current_user: current_user} do
    post = fixture(:post, current_user)
    conn = delete conn, post_path(conn, :delete, post)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, post)
    end
  end

  test "does not deletes chosen post, if user is not valid", %{conn: conn, current_user: current_user} do
    post = fixture(:post)
    conn = delete conn, post_path(conn, :delete, post)
    assert json_response(conn, 401)["errors"] != %{}
  end
end
