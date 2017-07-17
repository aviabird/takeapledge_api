defmodule TakeaplegeApi.Web.CommentView do
  use TakeaplegeApi.Web, :view
  alias TakeaplegeApi.Web.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      message: comment.message,
      post_id: comment.post_id.
      user_id: comment.user_id}
  end
end
