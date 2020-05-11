defmodule ApiWeb.PageController do
  use ApiWeb, :controller

  def index(conn, _params) do
    html =
      Phoenix.View.render_to_string(ApiWeb.PageView, "index.html",
        layout: {ApiWeb.LayoutView, "pdf.html"},
        conn: conn,
        css: "#{Application.app_dir(:api, "priv/static/css/app.css")}"
      )

    pdf_path = Path.absname("invoice.pdf")

    options = [
      format: "A4",
      print_background: true,
      debug: true,
      # value passed directly to Task.await/2. (Defaults to 5000)
      timeout: 10000
    ]

    case PuppeteerPdf.Generate.from_string(html, pdf_path, options) do
      {:ok, _} ->
        render(conn, "index.html")

      {:error, _} ->
        render(conn, "index.html")
    end
  end
end
