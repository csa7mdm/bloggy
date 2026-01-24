defmodule BloggyWeb.API.ContextController do
  use BloggyWeb, :controller
  alias Bloggy.Schema

  def show(conn, %{"id" => id}) do
    post = Schema.get_post!(id)
    
    # Calculate basic tokens (approximate)
    word_count = post.body |> String.split() |> length()
    token_est = round(word_count * 1.3)

    json(conn, %{
      id: post.id,
      title: post.title,
      published_at: post.publish_date,
      metadata: %{
        word_count: word_count,
        token_estimate: token_est,
        source: "bloggy-context-api-v1"
      },
      content: %{
        format: "markdown",
        body: post.body
      }
    })
  end
end
