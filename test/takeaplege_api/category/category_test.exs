defmodule TakeaplegeApi.CategoryTest do
  use TakeaplegeApi.DataCase

  alias TakeaplegeApi.Category
  alias TakeaplegeApi.App

  describe "posts" do
    alias TakeaplegeApi.Category.Post

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    @user_attrs %{
      email: "test@aviabird.com", password: "s3cr3t",
      name: "Test", bio: "Test"}
    @category_attrs %{desc: "some desc", title: "some title"}

    def post_fixture(attrs \\ %{}) do
      {:ok, user} = App.create_user(@user_attrs)
      {:ok, category} = App.create_category(@category_attrs)
      {:ok, post} =
        attrs
        |> Enum.into(
          @valid_attrs
          |> Map.put(:category_id, category.id)
          |> Map.put(:user_id, user.id)
        )
        |> Category.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Category.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Category.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      {:ok, user} = App.create_user(@user_attrs)
      {:ok, category} = App.create_category(@category_attrs)
      assert {:ok, %Post{} = post} = Category.create_post(
        @valid_attrs
        |> Map.put(:category_id, category.id)
        |> Map.put(:user_id, user.id))
      assert post.content == "some content"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Category.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Category.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Category.update_post(post, @invalid_attrs)
      assert post == Category.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Category.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Category.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Category.change_post(post)
    end
  end
end
