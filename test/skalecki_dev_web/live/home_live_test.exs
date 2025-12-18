defmodule SkaleckiDevWeb.HomeLiveTest do
  use SkaleckiDevWeb.ConnCase

  test "GET / renders homepage", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Jakub Skalecki"
    assert html_response(conn, 200) =~ "skalecki.dev"
  end
end
