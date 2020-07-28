defmodule Api.Email do
  import Bamboo.Email
  import Bamboo.Phoenix

  def create_receipt_email(pdf, receipt_details, receipt_template, organization) do
    new_email(
      to: "ian.knauer@gmail.com",
      from: "info@davos.gives",
      subject: "Thank you for donation to #{organization.name}!",
      html_body: "#{receipt_template.description}"
    )
    |> put_attachment(%Bamboo.Attachment{filename: "donation.pdf", data: pdf})
  end
end
