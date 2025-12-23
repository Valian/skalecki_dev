%{
  title: "Building a Blog with Phoenix and NimblePublisher",
  description: "How to create a fast, compile-time blog engine in Elixir using NimblePublisher. No database, no runtime overhead, just markdown files and pattern matching.",
  tags: ["elixir", "phoenix", "nimble_publisher", "blog"]
}
---

After years of reaching for heavyweight CMS solutions, I finally built exactly the blog I wanted — using NimblePublisher and about 100 lines of Elixir. No database. No runtime overhead. Just markdown files that compile into your application.

This post walks through the implementation, including some patterns I've found useful like automatic reading time calculation, tag support, and hidden/draft posts.

## Why NimblePublisher?

[NimblePublisher](https://github.com/dashbitco/nimble_publisher) is a minimal library from Dashbit that compiles markdown files into Elixir structs at build time. The approach has several advantages:

1. **Zero runtime overhead** — Posts are compiled into module attributes. Reading a post is just accessing data that's already in memory.
2. **Git-based workflow** — Posts live as markdown files in your repo. Version control, PRs for reviews, and easy local editing.
3. **Full Elixir control** — No database migrations, no admin panels. Just code.
4. **Syntax highlighting included** — Uses [Makeup](https://github.com/elixir-makeup/makeup) for code highlighting at compile time.

The tradeoff is that you need to redeploy to publish. For a personal blog, that's a feature, not a bug.

## The Post Schema

Here's the complete post struct:

```elixir
defmodule MyApp.Blog.Post do
  @enforce_keys [:id, :slug, :title, :description, :body, :date, :reading_time]
  defstruct [:id, :slug, :title, :description, :body, :date, :reading_time, :tags, hidden: false]

  def build(filename, attrs, body) do
    [year, month, day, slug] = parse_filename(filename)
    date = Date.new!(year, month, day)
    reading_time = calculate_reading_time(body)

    struct!(
      __MODULE__,
      [
        id: slug,
        slug: slug,
        date: date,
        body: body,
        reading_time: reading_time,
        tags: Map.get(attrs, :tags, []),
        hidden: Map.get(attrs, :hidden, false)
      ] ++ Map.to_list(attrs)
    )
  end

  defp parse_filename(filename) do
    [year, month, day, slug] =
      filename
      |> Path.basename(".md")
      |> String.split("-", parts: 4)

    [String.to_integer(year), String.to_integer(month), String.to_integer(day), slug]
  end

  defp calculate_reading_time(body) do
    word_count =
      body
      |> String.replace(~r/<[^>]+>/, "")
      |> String.split(~r/\s+/)
      |> length()

    minutes = max(1, div(word_count, 200))
    if minutes == 1, do: "1 min", else: "#{minutes} min"
  end
end
```

The `build/3` function is called by NimblePublisher for each markdown file. Note:

- **Filename parsing** — Date comes from the filename (`2024-12-23-my-post.md`), not frontmatter. One less thing to keep in sync.
- **Reading time** — Calculated automatically at ~200 words per minute after stripping HTML tags.
- **Hidden posts** — Defaults to `false`, allowing delisted posts that are still accessible via direct URL.

## The Blog Module

This is where NimblePublisher does its work:

```elixir
defmodule MyApp.Blog do
  alias MyApp.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:my_app, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: []

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})
  @visible_posts Enum.reject(@posts, & &1.hidden)

  def all_posts, do: @visible_posts

  def recent_posts(count \\ 3) do
    @visible_posts |> Enum.take(count)
  end

  def get_post_by_slug!(slug) do
    Enum.find(@posts, &(&1.slug == slug)) ||
      raise MyApp.Blog.NotFoundError, slug: slug
  end

  def all_tags do
    @visible_posts
    |> Enum.flat_map(& &1.tags)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def posts_by_tag(tag) do
    Enum.filter(@visible_posts, &(tag in &1.tags))
  end
end

defmodule MyApp.Blog.NotFoundError do
  defexception [:slug, plug_status: 404]

  @impl true
  def message(%{slug: slug}) do
    "Post not found: #{slug}"
  end
end
```

Key details:

- **`@posts` is a module attribute** — NimblePublisher populates it at compile time with all parsed posts.
- **`@visible_posts`** — A separate attribute filtering out hidden posts. Public functions use this, while `get_post_by_slug!/1` searches all posts (so hidden posts remain accessible via direct link).
- **Custom error** — The `NotFoundError` with `plug_status: 404` integrates nicely with Phoenix's error handling.

## Post Frontmatter

Posts use Elixir map syntax in frontmatter:

```markdown
%{
  title: "My Post Title",
  description: "A brief description for SEO and previews.",
  tags: ["elixir", "phoenix"],
  hidden: true
}
---

Your markdown content here...
```

This is parsed as Elixir code, so you get compile-time validation. Typos in field names will cause build failures, not silent bugs.

## Routing

Standard Phoenix routing:

```elixir
scope "/", MyAppWeb do
  pipe_through :browser

  get "/", PageController, :home
  get "/blog", PageController, :blog_index
  get "/blog/:slug", PageController, :blog_show
end
```

## Controller

```elixir
defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  alias MyApp.Blog

  def home(conn, _params) do
    conn
    |> assign(:posts, Blog.recent_posts(3))
    |> render(:home)
  end

  def blog_index(conn, _params) do
    conn
    |> assign(:posts, Blog.all_posts())
    |> render(:blog_index)
  end

  def blog_show(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug!(slug)
    all_posts = Blog.all_posts()
    {prev_post, next_post} = find_adjacent_posts(post, all_posts)

    conn
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
end
```

The `find_adjacent_posts/2` function enables previous/next navigation between posts.

## Dependencies

Add these to your `mix.exs`:

```elixir
defp deps do
  [
    {:nimble_publisher, "~> 1.1"},
    {:makeup, ">= 0.0.0"},
    {:makeup_elixir, ">= 0.0.0"},
    {:makeup_erlang, ">= 0.0.0"}
  ]
end
```

The Makeup libraries provide syntax highlighting for Elixir and Erlang code blocks. Add `makeup_js`, `makeup_html`, etc. for other languages.

## Rendering the Post Body

In your template, render the HTML body with `Phoenix.HTML.raw/1`:

```heex
<article class="prose">
  {Phoenix.HTML.raw(@post.body)}
</article>
```

The `prose` class from [Tailwind Typography](https://tailwindcss.com/docs/typography-plugin) handles styling for rendered markdown content.

## SEO with JSON-LD

For search engines, add structured data:

```heex
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    "headline": <%= Jason.encode!(@post.title) %>,
    "description": <%= Jason.encode!(@post.description) %>,
    "datePublished": "<%= Date.to_iso8601(@post.date) %>",
    "author": {
      "@type": "Person",
      "name": "Your Name",
      "url": "https://yoursite.com"
    }
  }
</script>
```

## Live Reloading During Development

NimblePublisher compiles posts at build time, so by default you need to recompile to see changes. Add this to your Phoenix endpoint for automatic reloading:

```elixir
# config/dev.exs
config :my_app, MyAppWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/posts/.*(md)$",
      # ... other patterns
    ]
  ]
```

## Wrapping Up

The full implementation is about 100 lines of code. No database schema to maintain, no admin interface to secure, no runtime queries to optimize. Posts are just data baked into your compiled application.

For a personal blog or documentation site, this approach hits a sweet spot: simple enough to understand completely, powerful enough to not need anything else.
