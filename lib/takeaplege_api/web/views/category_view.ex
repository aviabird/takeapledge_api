defmodule TakeaplegeApi.Web.CategoryView do
  use TakeaplegeApi.Web, :view
  alias TakeaplegeApi.Web.CategoryView

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id,
      title: category.title,
      desc: category.desc}
  end
end
