defmodule TakeaplegeApi.Web.PostController do
  use TakeaplegeApi.Web, :controller

  alias TakeaplegeApi.Category
  alias TakeaplegeApi.Category.Post

  action_fallback TakeaplegeApi.Web.FallbackController

  plug :scrub_params, "post" when action in [:create, :update]

  plug TakeaplegeApi.Authentication when not action in [:index, :show]

  def index(conn, _params) do
    posts = Category.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <-
      Category.create_post(
        Map.put(post_params, "user_id", conn.assigns.current_user.id))
    do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Category.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Category.get_post!(id)
    with  {:ok, :authorized} <- can_edit?(conn, Dict.get(post_params, "user_id", nil)),
          {:ok, %Post{} = post} <- Category.update_post(post, post_params)
    do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Category.get_post!(id)
    with  {:ok, :authorized} <- can_delete?(conn, post.user_id),
          {:ok, %Post{}} <- Category.delete_post(post)
    do
      send_resp(conn, :no_content, "")
    end
  end

  defp can_edit?(conn, user_id) do
    case conn.assigns.current_user.id == user_id do
      true -> {:ok, :authorized}
      false -> {:error, :unauthorized}
    end
  end

  defp can_delete?(conn, user_id), do: can_edit?(conn, user_id)

end
