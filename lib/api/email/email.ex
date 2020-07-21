defmodule Api.Email do
  import Bamboo.Email
  import Bamboo.Phoenix

  def send_initial_receipt(receipt) do
    new_email(
      to: "ian.knauer@gmail.com",
      from: "info@davos.gives",
      subject: "Welcome to Davos! Please confirm your account",
      html_body: "Hey testing!,<br /><br /><strong>"
    )
    |> put_attachment(%Bamboo.Attachment{filename: "invoice.pdf", data: receipt})
  end

  def create_receipt_email(pdf, receipt_details, organization) do
    new_email(
      to: "ian.knauer@gmail.com",
      from: "info@davos.gives",
      subject: "Thank you for donation to #{organization.name}!",
      html_body: "Hey testing to make sure we get some email :),<br /><br /><strong>"
    )
    |> put_attachment(%Bamboo.Attachment{filename: "donation.pdf", data: pdf})
  end
end
