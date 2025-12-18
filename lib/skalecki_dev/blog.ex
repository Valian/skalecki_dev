defmodule SkaleckiDev.Blog do
  alias SkaleckiDev.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:skalecki_dev, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  def all_posts, do: @posts

  def recent_posts(count \\ 3) do
    @posts |> Enum.take(count)
  end

  def get_post_by_slug!(slug) do
    Enum.find(@posts, &(&1.slug == slug)) ||
      raise SkaleckiDev.Blog.NotFoundError, slug: slug
  end

  def all_tags do
    @posts
    |> Enum.flat_map(& &1.tags)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def posts_by_tag(tag) do
    Enum.filter(@posts, &(tag in &1.tags))
  end
end

defmodule SkaleckiDev.Blog.NotFoundError do
  defexception [:slug, plug_status: 404]

  @impl true
  def message(%{slug: slug}) do
    "Post not found: #{slug}"
  end
end
