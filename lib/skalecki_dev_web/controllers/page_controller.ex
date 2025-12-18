defmodule SkaleckiDevWeb.PageController do
  use SkaleckiDevWeb, :controller

  alias SkaleckiDev.Blog

  def home(conn, _params) do
    conn
    |> assign(:page_title, nil)
    |> assign(:posts, Blog.recent_posts(3))
    |> assign(:projects, projects())
    |> render(:home)
  end

  def blog_index(conn, _params) do
    conn
    |> assign(:page_title, "Thoughts")
    |> assign(:posts, Blog.all_posts())
    |> render(:blog_index)
  end

  def blog_show(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug!(slug)
    all_posts = Blog.all_posts()
    {prev_post, next_post} = find_adjacent_posts(post, all_posts)

    conn
    |> assign(:page_title, post.title)
    |> assign(:post, post)
    |> assign(:prev_post, prev_post)
    |> assign(:next_post, next_post)
    |> render(:blog_show)
  end

  defp find_adjacent_posts(current, posts) do
    idx = Enum.find_index(posts, &(&1.slug == current.slug))

    prev_post = if idx && idx > 0, do: Enum.at(posts, idx - 1)
    next_post = if idx, do: Enum.at(posts, idx + 1)

    {prev_post, next_post}
  end

  defp projects do
    [
      %{
        name: "postline.ai",
        type: :professional,
        year: "2024",
        description:
          "LinkedIn AI assistant for crafting engaging posts and growing your professional presence.",
        tags: ["AI", "LinkedIn", "Content Generation"],
        url: "https://postline.ai",
        icon: nil
      },
      %{
        name: "researchmate.ai",
        type: :professional,
        year: "2024",
        description:
          "Deep research tool - automated comprehensive research before it was trendy.",
        tags: ["AI", "Research", "RAG"],
        url: "https://researchmate.ai",
        icon: nil
      },
      %{
        name: "LiveVue",
        type: :open_source,
        year: "2024",
        description:
          "Bridge between Phoenix LiveView and Vue.js - best of both worlds for interactive UIs.",
        tags: ["Elixir", "Vue.js", "Phoenix", "LiveView"],
        url: "https://github.com/Valian/live_vue",
        icon: nil
      }
    ]
  end
end
