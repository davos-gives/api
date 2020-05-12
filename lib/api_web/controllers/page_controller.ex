defmodule ApiWeb.PageController do
  use ApiWeb, :controller

  require IEx

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
