defmodule SkaleckiDevWeb.HomeLive do
  use SkaleckiDevWeb, :live_view

  alias SkaleckiDev.Blog

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, nil)
     |> assign(:posts, Blog.recent_posts(3))
     |> assign(:projects, projects())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grain"></div>

    <nav
      id="navbar"
      class="fixed top-0 left-0 right-0 z-40 transition-all duration-300 py-6 bg-transparent"
    >
      <div class="max-w-6xl mx-auto px-6 flex justify-between items-center">
        <a
          href="#"
          class="font-mono text-sm tracking-widest uppercase font-bold text-primary hover:text-base-content transition-colors"
        >
          skalecki<span class="text-base-content">.dev</span>
        </a>

        <div class="flex gap-6 items-center">
          <div class="hidden sm:flex gap-8 text-sm font-mono text-secondary">
            <a href="#projects" class="hover:text-base-content transition-colors">Work</a>
            <a href="#thoughts" class="hover:text-base-content transition-colors">Thoughts</a>
            <a href="#contact" class="hover:text-base-content transition-colors">Contact</a>
          </div>
          <Layouts.theme_toggle />
        </div>
      </div>
    </nav>

    <main class="font-sans">
      <.hero_section />
      <.tech_ticker />
      <.projects_section projects={@projects} />
      <.thoughts_section posts={@posts} />
    </main>

    <.footer_section />
    <Layouts.flash_group flash={@flash} />
    """
  end

  defp hero_section(assigns) do
    ~H"""
    <section class="min-h-screen flex flex-col justify-center pt-24 relative overflow-hidden">
      <div class="absolute top-1/3 right-0 w-[600px] h-[600px] bg-primary rounded-full blur-[120px] -z-10 opacity-10 pointer-events-none">
      </div>

      <div class="animate-fade-in space-y-10 px-6 max-w-6xl mx-auto w-full">
        <div class="flex flex-col md:flex-row items-start md:items-center gap-6 mb-8">
          <div class="relative group">
            <div class="absolute -inset-0.5 bg-gradient-to-r from-primary to-warning rounded-full opacity-75 blur group-hover:opacity-100 transition duration-1000 group-hover:duration-200">
            </div>
            <img
              src="https://github.com/Valian.png"
              alt="Jakub Skalecki"
              class="relative w-20 h-20 md:w-24 md:h-24 rounded-full border-2 border-base-200 object-cover grayscale group-hover:grayscale-0 transition-all duration-500"
            />
          </div>

          <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-base-content/10 bg-base-content/5 font-mono text-xs text-primary">
            <span class="relative flex h-2 w-2">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75">
              </span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-primary"></span>
            </span>
            Building tools that matter
          </div>
        </div>

        <h1 class="font-serif text-5xl md:text-7xl lg:text-8xl leading-[0.95] tracking-tight text-base-content">
          Impact over<br />
          <span class="italic text-secondary/70">boilerplate.</span>
        </h1>

        <div class="max-w-2xl animate-slide-up" style="animation-delay: 0.2s">
          <p class="font-sans text-lg md:text-xl text-secondary leading-relaxed border-l-2 border-primary/50 pl-6 mb-6">
            I'm <strong class="text-base-content">Jakub Skalecki</strong>
            (Valian). I specialize in high-leverage engineering for ambitious companies.
          </p>
          <p class="font-sans text-base md:text-lg text-secondary/80 leading-relaxed pl-6">
            I don't just write code; I challenge requirements to ensure we build what actually matters.
            Goal-oriented and direct, I bridge the gap between technical complexity and business value.
            <br /><br /> Currently deep-diving into
            <span class="text-primary">Applied AI Engineering</span>
            and Elixir ecosystems.
          </p>
        </div>

        <div
          class="flex flex-col md:flex-row gap-8 pt-8 font-mono text-sm animate-slide-up"
          style="animation-delay: 0.4s"
        >
          <div class="flex items-center gap-3 text-secondary">
            <.icon name="hero-cpu-chip" class="text-primary size-4" />
            <span>AI Engineering</span>
          </div>
          <div class="flex items-center gap-3 text-secondary">
            <.icon name="hero-bolt" class="text-primary size-4" />
            <span>Elixir & Phoenix</span>
          </div>
          <div class="flex items-center gap-3 text-secondary">
            <.icon name="hero-rocket-launch" class="text-primary size-4" />
            <span>Product Strategy</span>
          </div>
        </div>
      </div>

      <a
        href="#projects"
        class="absolute bottom-12 left-1/2 -translate-x-1/2 text-secondary/50 hover:text-primary transition-colors animate-bounce"
      >
        <.icon name="hero-arrow-down" class="size-6" />
      </a>
    </section>
    """
  end

  defp tech_ticker(assigns) do
    ~H"""
    <div class="w-full border-y border-base-content/5 bg-base-content/[0.02] py-6 overflow-hidden flex relative z-10">
      <div class="animate-ticker flex whitespace-nowrap">
        <div class="flex gap-16 px-8">
          <%= for tech <- technologies() do %>
            <span class="font-mono text-xl text-base-content/20 uppercase font-bold tracking-tighter">
              {tech}
            </span>
          <% end %>
          <%= for tech <- technologies() do %>
            <span class="font-mono text-xl text-base-content/20 uppercase font-bold tracking-tighter">
              {tech}
            </span>
          <% end %>
          <%= for tech <- technologies() do %>
            <span class="font-mono text-xl text-base-content/20 uppercase font-bold tracking-tighter">
              {tech}
            </span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp projects_section(assigns) do
    ~H"""
    <section id="projects" class="py-32 px-6 max-w-6xl mx-auto">
      <div class="flex flex-col md:flex-row justify-between items-end mb-16 border-b border-base-content/10 pb-8">
        <h2 class="font-serif text-5xl text-base-content">Selected Works</h2>
        <p class="font-mono text-sm text-secondary pt-4 md:pt-0">Solving real problems</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-px bg-base-content/10 border border-base-content/5">
        <%= for project <- @projects do %>
          <.project_card project={project} />
        <% end %>
      </div>
    </section>
    """
  end

  defp project_card(assigns) do
    ~H"""
    <div class="group relative p-8 bg-base-100 hover:bg-base-200 transition-all duration-300">
      <div class="flex justify-between items-start mb-6">
        <span class={[
          "font-mono text-xs px-2 py-1 border rounded",
          @project.type == :open_source && "border-success/30 text-success",
          @project.type == :professional && "border-info/30 text-info"
        ]}>
          {if @project.type == :open_source, do: "OPEN SOURCE", else: "PROFESSIONAL"}
        </span>
        <span class="font-mono text-xs text-secondary/50">{@project.year}</span>
      </div>

      <div class="flex items-start gap-4 mb-3">
        <div
          :if={@project.icon}
          class="w-12 h-12 rounded-lg bg-base-300 flex items-center justify-center shrink-0"
        >
          <!-- Icon placeholder -->
        </div>
        <h3 class="font-serif text-3xl text-base-content group-hover:text-primary transition-colors">
          {@project.name}
        </h3>
      </div>

      <p class="font-sans text-secondary text-sm leading-relaxed mb-8 max-w-md">
        {@project.description}
      </p>

      <div class="flex flex-wrap gap-2 mb-8">
        <%= for tag <- @project.tags do %>
          <span class="text-xs font-mono text-secondary/70">#{tag}</span>
        <% end %>
      </div>

      <a
        :if={@project.url}
        href={@project.url}
        target="_blank"
        rel="noopener noreferrer"
        class="inline-flex items-center gap-2 font-mono text-sm text-primary opacity-0 -translate-y-2 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300"
      >
        {if @project.type == :open_source, do: "View Repository", else: "Visit Site"}
        <.icon name="hero-arrow-up-right" class="size-3" />
      </a>
    </div>
    """
  end

  defp thoughts_section(assigns) do
    ~H"""
    <section id="thoughts" class="py-24 px-6 max-w-6xl mx-auto">
      <div class="flex flex-col md:flex-row justify-between items-end mb-16 border-b border-base-content/10 pb-8">
        <h2 class="font-serif text-5xl text-base-content">Thoughts</h2>
        <.link
          navigate={~p"/blog"}
          class="font-mono text-sm text-secondary hover:text-primary transition-colors pt-4 md:pt-0 flex items-center gap-2"
        >
          View all <.icon name="hero-arrow-right" class="size-3" />
        </.link>
      </div>

      <div class="flex flex-col">
        <%= for post <- @posts do %>
          <.post_card post={post} />
        <% end %>
      </div>
    </section>
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
          <h3 class="font-serif text-3xl text-base-content mb-4 group-hover:text-primary transition-colors">
            {@post.title}
          </h3>
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
    <footer id="contact" class="bg-base-200 pt-32 pb-12 px-6 border-t border-base-content/5">
      <div class="max-w-6xl mx-auto">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-16 mb-24">
          <div>
            <h2 class="font-serif text-6xl md:text-8xl text-base-content mb-8 tracking-tight">
              Let's<br />Connect.
            </h2>
            <p class="font-sans text-xl text-secondary max-w-md">
              Always open to discussing functional architecture, Elixir adoption, AI engineering, or interesting collaborations.
            </p>
          </div>

          <div class="flex flex-col justify-end gap-6">
            <a
              href="https://github.com/Valian"
              target="_blank"
              rel="noopener noreferrer"
              class="group flex items-center justify-between py-6 border-b border-base-content/10 hover:border-primary transition-colors"
            >
              <span class="flex items-center gap-4 font-mono text-xl text-secondary group-hover:text-base-content transition-colors">
                <.icon
                  name="hero-code-bracket"
                  class="text-primary/50 group-hover:text-primary transition-colors size-6"
                /> GitHub
              </span>
              <span class="font-mono text-sm text-secondary/50 group-hover:text-primary group-hover:translate-x-[-10px] transition-all">
                @Valian
              </span>
            </a>

            <a
              href="https://twitter.com/jskalc"
              target="_blank"
              rel="noopener noreferrer"
              class="group flex items-center justify-between py-6 border-b border-base-content/10 hover:border-primary transition-colors"
            >
              <span class="flex items-center gap-4 font-mono text-xl text-secondary group-hover:text-base-content transition-colors">
                <.icon
                  name="hero-chat-bubble-left"
                  class="text-primary/50 group-hover:text-primary transition-colors size-6"
                /> Twitter
              </span>
              <span class="font-mono text-sm text-secondary/50 group-hover:text-primary group-hover:translate-x-[-10px] transition-all">
                @jskalc
              </span>
            </a>

            <a
              href="mailto:jakub@skalecki.dev"
              class="group flex items-center justify-between py-6 border-b border-base-content/10 hover:border-primary transition-colors"
            >
              <span class="flex items-center gap-4 font-mono text-xl text-secondary group-hover:text-base-content transition-colors">
                <.icon
                  name="hero-envelope"
                  class="text-primary/50 group-hover:text-primary transition-colors size-6"
                /> Email
              </span>
              <span class="font-mono text-sm text-secondary/50 group-hover:text-primary group-hover:translate-x-[-10px] transition-all">
                jakub@skalecki.dev
              </span>
            </a>
          </div>
        </div>

        <div class="flex flex-col md:flex-row justify-between items-center pt-8 border-t border-base-content/5 font-mono text-xs text-secondary/40">
          <p>&copy; {Date.utc_today().year} Jakub Skalecki (Valian). All rights reserved.</p>
          <p>Built with Phoenix LiveView & Tailwind.</p>
        </div>
      </div>
    </footer>
    """
  end

  defp technologies do
    [
      "Elixir",
      "Phoenix LiveView",
      "Python",
      "LLMs",
      "RAG Pipelines",
      "Vue.js",
      "System Architecture",
      "Docker"
    ]
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
