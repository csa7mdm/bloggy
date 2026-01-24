defmodule BloggyWeb.LLMController do
  use BloggyWeb, :controller
  alias Bloggy.Schema

  def index(conn, _params) do
    posts = Schema.list_posts()

    # Generate the llms.txt content
    # Format: 
    # - Title: [Title]
    #   Link: [URL]
    #   Description: [Excerpt]

    content =
      Enum.map_join(posts, "\n\n", fn post ->
        """
        - Title: #{post.title}
          Link: #{url(conn, ~p"/posts/#{post}")}
          Description: #{String.slice(post.body || "", 0, 200) |> String.replace("\n", " ")}...
        """
      end)

    header = """
    # Bloggy Content Map for AI Agents
    # This file provides a structured list of all accessible content on this blog.

    """

    conn
    |> put_resp_content_type("text/plain")
    |> text(header <> content)
  end
end
