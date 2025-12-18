defmodule SkaleckiDevWeb.SitemapController do
  use SkaleckiDevWeb, :controller

  alias SkaleckiDev.Blog

  plug :put_layout, false

  def index(conn, _params) do
    posts = Blog.all_posts()

    conn
    |> put_resp_content_type("application/xml")
    |> put_view(SkaleckiDevWeb.SitemapXML)
    |> render(:index, posts: posts)
  end
end
