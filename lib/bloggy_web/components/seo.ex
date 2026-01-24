defmodule BloggyWeb.SEO do
  use Phoenix.Component

  attr :title, :string, default: nil
  attr :description, :string, default: nil
  attr :url, :string, required: true
  attr :image, :string, default: nil

  def meta(assigns) do
    ~H"""
    <title>{page_title(@title)}</title>
    <meta name="description" content={@description || "Bloggy: The home of AI-native publishing."} />

    <!-- Open Graph -->
    <meta property="og:title" content={page_title(@title)} />
    <meta property="og:description" content={@description || "Bloggy: The home of AI-native publishing."} />
    <meta property="og:url" content={@url} />
    <%= if @image do %>
      <meta property="og:image" content={@image} />
    <% end %>
    <meta property="og:type" content="website" />
    <meta property="og:site_name" content="Bloggy" />

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content={page_title(@title)} />
    <meta name="twitter:description" content={@description || "Bloggy: The home of AI-native publishing."} />
    <%= if @image do %>
      <meta name="twitter:image" content={@image} />
    <% end %>
    """
  end

  defp page_title(nil), do: "Bloggy"
  defp page_title(title), do: "#{title} · Bloggy"
end
