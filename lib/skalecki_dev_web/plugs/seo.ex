defmodule SkaleckiDevWeb.Plugs.SEO do
  @moduledoc """
  Plug to set default SEO-related assigns for meta tags.
  """
  import Plug.Conn

  @default_description "Jakub Skałecki - Software Engineer specializing in Elixir, AI, and high-impact engineering. Building tools that matter."
  @default_image "/images/og-image.png"

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:meta_description, @default_description)
    |> assign(:meta_image, @default_image)
    |> assign(:meta_type, "website")
  end

  def default_description, do: @default_description
  def default_image, do: @default_image
end
