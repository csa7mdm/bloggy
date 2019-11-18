defmodule Bloggy.SchemaTest do
  use Bloggy.DataCase

  alias Bloggy.Schema

  describe "posts" do
    alias Bloggy.Schema.Post

    @valid_attrs %{description: "some description", name: "some name", tag: "some tag"}
    @update_attrs %{description: "some updated description", name: "some updated name", tag: "some updated tag"}
    @invalid_attrs %{description: nil, name: nil, tag: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schema.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Schema.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Schema.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Schema.create_post(@valid_attrs)
      assert post.description == "some description"
      assert post.name == "some name"
      assert post.tag == "some tag"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Schema.update_post(post, @update_attrs)
      assert post.description == "some updated description"
      assert post.name == "some updated name"
      assert post.tag == "some updated tag"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_post(post, @invalid_attrs)
      assert post == Schema.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Schema.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Schema.change_post(post)
    end
  end

  describe "posts" do
    alias Bloggy.Schema.Post

    @valid_attrs %{approved: true, company_id: 42, content: "some content", created_by: 42, publish_date: "2010-04-17T14:00:00Z", tag: "some tag", title: "some title"}
    @update_attrs %{approved: false, company_id: 43, content: "some updated content", created_by: 43, publish_date: "2011-05-18T15:01:01Z", tag: "some updated tag", title: "some updated title"}
    @invalid_attrs %{approved: nil, company_id: nil, content: nil, created_by: nil, publish_date: nil, tag: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schema.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Schema.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Schema.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Schema.create_post(@valid_attrs)
      assert post.approved == true
      assert post.company_id == 42
      assert post.content == "some content"
      assert post.created_by == 42
      assert post.publish_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert post.tag == "some tag"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Schema.update_post(post, @update_attrs)
      assert post.approved == false
      assert post.company_id == 43
      assert post.content == "some updated content"
      assert post.created_by == 43
      assert post.publish_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert post.tag == "some updated tag"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_post(post, @invalid_attrs)
      assert post == Schema.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Schema.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Schema.change_post(post)
    end
  end

  describe "companies" do
    alias Bloggy.Schema.Company

    @valid_attrs %{name: "some name", parent_id: 42}
    @update_attrs %{name: "some updated name", parent_id: 43}
    @invalid_attrs %{name: nil, parent_id: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schema.create_company()

      company
    end

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Schema.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Schema.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Schema.create_company(@valid_attrs)
      assert company.name == "some name"
      assert company.parent_id == 42
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Schema.update_company(company, @update_attrs)
      assert company.name == "some updated name"
      assert company.parent_id == 43
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_company(company, @invalid_attrs)
      assert company == Schema.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Schema.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Schema.change_company(company)
    end
  end
end
