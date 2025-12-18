# skalecki.dev - Project Status

## Overview

Personal website for Jakub Skalecki (GitHub: Valian) built with Phoenix LiveView.

**Domain:** skalecki.dev
**Email:** jakub@skalecki.dev
**Twitter:** @jskalc
**GitHub:** @Valian

## What's Implemented

### Homepage (HomeLive)

- **Navigation**: Fixed nav with logo, Work/Thoughts/Contact links, theme toggle (light/dark/system)
- **Hero Section**: Avatar from GitHub, animated badge, headline "Impact over boilerplate", bio, tech badges
- **Tech Ticker**: Scrolling marquee (Elixir, Phoenix LiveView, Python, LLMs, RAG Pipelines, Vue.js, System Architecture, Docker)
- **Projects Section**: 3 real projects displayed in grid
- **Thoughts Section**: 3 fake blog posts (placeholder for NimblePublisher)
- **Footer**: Contact section with GitHub, Twitter, Email links

### Styling

- Custom daisyUI themes (dark/light) with orange primary color
- Custom fonts: Playfair Display (serif), JetBrains Mono (mono), Inter (sans)
- Animations: fade-in, slide-up, ticker scroll
- Grain texture overlay
- Custom scrollbar (dark theme)

### Projects Listed

| Name | Type | URL |
|------|------|-----|
| postline.ai | Professional | https://postline.ai |
| researchmate.ai | Professional | https://researchmate.ai |
| LiveVue | Open Source | https://github.com/Valian/live_vue |

## What's Missing / Next Steps

### 1. Project Icons
Add icons for each project in `priv/static/images/`:
- `postline-icon.png` (or svg)
- `researchmate-icon.png`
- `livevue-icon.png`

Then update `lib/skalecki_dev_web/live/home_live.ex` `projects/0` function to reference them.

### 2. Blog with NimblePublisher
Set up markdown-based blog:

1. Add dependency to `mix.exs`:
   ```elixir
   {:nimble_publisher, "~> 1.0"}
   ```

2. Create `priv/posts/` directory for markdown files

3. Create a Blog context module with NimblePublisher

4. Replace `fake_posts/0` with real posts from NimblePublisher

5. Add routes for individual blog posts (`/blog/:slug`)

### 3. Individual Blog Post Page
- Create `BlogLive` or `PostLive` for `/blog/:slug`
- Markdown rendering with syntax highlighting
- Reading time calculation
- Previous/next post navigation

### 4. SEO Improvements
- Open Graph meta tags
- Twitter card meta tags
- Structured data (JSON-LD)
- Sitemap.xml
- robots.txt updates

### 5. Optional Enhancements
- RSS feed for blog
- Newsletter signup
- Analytics integration
- Contact form
- Mobile hamburger menu (currently nav links hidden on small screens)

## File Structure

```
lib/skalecki_dev_web/
├── live/
│   └── home_live.ex          # Main homepage
├── components/
│   ├── layouts.ex            # Layout components (theme_toggle, flash_group)
│   ├── layouts/root.html.heex
│   └── core_components.ex
└── router.ex                 # Routes

assets/css/
└── app.css                   # Tailwind + daisyUI config, custom CSS

docs/
└── PROJECT_STATUS.md         # This file
```

## Commands

```bash
# Start dev server
mix phx.server

# Run tests
mix test

# Pre-commit checks (compile, format, test, deps)
mix precommit
```
