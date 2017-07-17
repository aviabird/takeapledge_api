defmodule TakeaplegeApi.Web.CommentController do
  use TakeaplegeApi.Web, :controller

  alias TakeaplegeApi.Post
  alias TakeaplegeApi.Post.Comment
  alias TakeaplegeApi.Web.CommentsChannel

  action_fallback TakeaplegeApi.Web.FallbackController

  def index(conn, _params) do
    comments = Post.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Post.create_comment(comment_params) do
      CommentsChannel.broadcast_create(comment)
      conn
      |> put_status(:created)
      |> put_resp_header("location", comment_path(conn, :show, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Post.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Post.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Post.update_comment(comment, comment_params) do
      CommentsChannel.broadcast_create(comment)
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Post.get_comment!(id)
    with {:ok, %Comment{}} <- Post.delete_comment(comment) do
      CommentsChannel.broadcast_delete(id)
      send_resp(conn, :no_content, "")
    end
  end
end
