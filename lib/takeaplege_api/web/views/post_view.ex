defmodule TakeaplegeApi.Web.PostView do
  use TakeaplegeApi.Web, :view
  alias TakeaplegeApi.Web.{PostView, UserView}

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      content: post.content,
      category_id: post.category_id,
      user_id: post.user_id,
      user: render_one(post.user, UserView, "user.json")}
  end
end
