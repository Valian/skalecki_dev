defmodule SkaleckiDevWeb.PageHTML do
  use SkaleckiDevWeb, :html

  embed_templates "page_html/*"

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
end
