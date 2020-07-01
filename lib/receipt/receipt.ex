defmodule Api.Receipt do
  def generate_receipt(receipt, receipt_template, organization) do
    html =
      Phoenix.View.render_to_string(ApiWeb.ReceiptView, "default.html",
        layout: {ApiWeb.LayoutView, "pdf.html"},
        css: "#{Application.app_dir(:api, "priv/static/css/app.css")}",
        template: receipt_template,
        donation: receipt,
        organization: organization
      )

    pdf_path = Path.absname("receipts/#{receipt.receipt_number}.pdf")    

    options = [
      format: "A4",
      print_background: true,
      debug: false
    ]

    PuppeteerPdf.Generate.from_string(html, pdf_path, options)

    {:ok, file_id} = Api.FileStore.put_file(Path.absname("receipts"), pdf_path)
  end
end
