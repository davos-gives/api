defmodule Api.Receipt do
  # TODO: Pass in receipt info (template, receipt info, receipt number from actual stack)
  def generate_receipt(donation) do
    html =
      Phoenix.View.render_to_string(ApiWeb.ReceiptView, "default.html",
        layout: {ApiWeb.LayoutView, "pdf.html"},
        css: "#{Application.app_dir(:api, "priv/static/css/app.css")}",
        template: %{
          header: "Thanks for being Awesome!",
          description:
            "After 18 years in the same location, the Barks & Moews Shelter faced a move. In addition to finding a suitable location that will permit us to continue our work, major renovations and modification may well be required. Your assistance to our organization is greatly appreciated. You are helping our shelter reach our goal; our survival is in your hands.",
          logo: "#{Application.app_dir(:api, "priv/static/images/barks.png")}",
          signature: "#{Application.app_dir(:api, "priv/static/images/signature.png")}",
          davos: "#{Application.app_dir(:api, "priv/static/images/davos-logo.png")}"
        },
        donation: donation
      )

    pdf_path = Path.absname("#{donation.id}.pdf")

    options = [
      format: "A4",
      print_background: true,
      debug: false
    ]

    PuppeteerPdf.Generate.from_string(html, pdf_path, options)
  end
end
