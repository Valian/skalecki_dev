defmodule SkaleckiDev.Blog.Post do
  @enforce_keys [:id, :slug, :title, :description, :body, :date, :reading_time]
  defstruct [:id, :slug, :title, :description, :body, :date, :reading_time, :tags]

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
        tags: Map.get(attrs, :tags, [])
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
