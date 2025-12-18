defmodule SkaleckiDevWeb.BlogLive do
  use SkaleckiDevWeb, :live_view

  alias SkaleckiDev.Blog

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Thoughts")
     |> assign(:posts, Blog.all_posts())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="grain"></div>

      <nav class="fixed top-0 left-0 right-0 z-40 py-6 bg-base-100/80 backdrop-blur-sm border-b border-base-content/5">
        <div class="max-w-4xl mx-auto px-6 flex justify-between items-center">
          <a
            href="/"
            class="font-mono text-sm tracking-widest uppercase font-bold text-primary hover:text-base-content transition-colors"
          >
            skalecki<span class="text-base-content">.dev</span>
          </a>

          <div class="flex gap-6 items-center">
            <div class="hidden sm:flex gap-8 text-sm font-mono text-secondary">
              <a href="/#projects" class="hover:text-base-content transition-colors">Work</a>
              <a href="/blog" class="text-primary">Thoughts</a>
              <a href="/#contact" class="hover:text-base-content transition-colors">Contact</a>
            </div>
            <Layouts.theme_toggle />
          </div>
        </div>
      </nav>

      <main class="font-sans pt-32 pb-24 px-6 max-w-4xl mx-auto min-h-screen">
        <header class="mb-16 animate-fade-in">
          <h1 class="font-serif text-5xl md:text-6xl text-base-content mb-6">Thoughts</h1>
          <p class="font-sans text-xl text-secondary max-w-2xl leading-relaxed">
            Engineering journal. Notes on building software, working with AI, and navigating the craft.
          </p>
        </header>

        <div class="flex flex-col animate-slide-up" style="animation-delay: 0.2s">
          <%= for post <- @posts do %>
            <.post_card post={post} />
          <% end %>
        </div>

        <%= if @posts == [] do %>
          <div class="text-center py-16">
            <p class="font-mono text-secondary/50">No posts yet. Check back soon.</p>
          </div>
        <% end %>
      </main>

      <.footer_section />
    </Layouts.app>
    """
  end

  defp post_card(assigns) do
    ~H"""
    <.link
      navigate={~p"/blog/#{@post.slug}"}
      class="group py-12 border-b border-base-content/5 hover:bg-base-content/[0.02] transition-colors block"
    >
      <article class="flex flex-col md:flex-row gap-8 justify-between">
        <div class="md:w-1/4">
          <time class="font-mono text-sm text-primary/80 block mb-2">
            {Calendar.strftime(@post.date, "%b %d, %Y")}
          </time>
          <span class="font-mono text-xs text-secondary/40">{@post.reading_time} read</span>
        </div>
        <div class="md:w-3/4">
          <h2 class="font-serif text-3xl text-base-content mb-4 group-hover:text-primary transition-colors">
            {@post.title}
          </h2>
          <p class="font-sans text-secondary leading-relaxed max-w-2xl">
            {@post.description}
          </p>
          <div class="mt-6 flex items-center gap-2 text-sm font-mono text-base-content/40 group-hover:text-base-content transition-colors">
            <span>Read Article</span>
            <.icon
              name="hero-arrow-right"
              class="size-4 transform group-hover:translate-x-2 transition-transform duration-300"
            />
          </div>
        </div>
      </article>
    </.link>
    """
  end

  defp footer_section(assigns) do
    ~H"""
    <footer class="bg-base-200 py-12 px-6 border-t border-base-content/5">
      <div class="max-w-4xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4 font-mono text-xs text-secondary/40">
        <p>&copy; {Date.utc_today().year} Jakub Skalecki (Valian). All rights reserved.</p>
        <a href="/" class="hover:text-primary transition-colors">Back to Home</a>
      </div>
    </footer>
    """
  end
end
