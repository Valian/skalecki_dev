defmodule SkaleckiDevWeb.PageController do
  use SkaleckiDevWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
