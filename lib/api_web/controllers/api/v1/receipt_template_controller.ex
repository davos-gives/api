defmodule ApiWeb.API.V1.ReceiptTemplateController do
  use ApiWeb, :controller 

  alias Api.Organization
  alias Api.Organization.ReceiptTemplate
  
  import IEx

  plug :get_database_prefix

  def index(conn, params) do 
    templates = Organization.list_receipt_templates_for_organization(params.prefix)
    render(conn, "index.json-api", data: templates)
  end

  def show(conn, %{"id" => id} = params) do
    template = Organization.get_receipt_template!(id, params.prefix)

    gift = %{
      first_name: "Jane", 
      last_name: "Doe",
      address_2: "123",
      address_1: "1001 East street",
      payment_date: "2020-05-13T18:14:02-07:00",
      date_format: "DD / MM / YY",
      city: "Vancouver",
      province: "BC",
      country: "Canada",
      postal_code: "V3H4X9",
      payment_amount: 10000,
      advantage_value: 0,
      amount_eligable_for_tax_purposes: 10000
    }

    html = Phoenix.View.render_to_string(ApiWeb.ReceiptView, "default.html",
    layout: {ApiWeb.LayoutView, "pdf.html"},
    css: "#{Application.app_dir(:api, "priv/static/css/app.css")}",
    template: template,
    donation: gift,
    organization: Organization.get_organization!(conn.assigns.current_user.organization_id)
    )

    new_template = template
    |> Map.put(:template_code, html)
    render(conn, "show.json-api", data: new_template)
  end

  def create(conn, %{"data" => data = %{"type" => "receipt-templates"}} = params) do
    data = data
    |> JaSerializer.Params.to_attributes
  
    case Organization.create_receipt_template(data, params.prefix) do
      {:ok, %ReceiptTemplate{} = receipt_template} ->
        conn
        |> put_status(:created)
        |> render("show.json-api", data: receipt_template)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset)
    end
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "receipt-templates"}} = params) do 
    data = JaSerializer.Params.to_attributes(data)
    template = Organization.get_receipt_template!(id, params.prefix)

    case Organization.update_receipt_template(template, data, params.prefix) do
      {:ok, %ReceiptTemplate{} = template} ->

        gift = %{
          first_name: "Jane", 
          last_name: "Doe",
          address_2: "123",
          address_1: "1001 East street",
          payment_date: "2020-05-13T18:14:02-07:00",
          date_format: "DD / MM / YY",
          city: "Vancouver",
          province: "BC",
          country: "Canada",
          postal_code: "V3H4X9",
          payment_amount: 10000,
          advantage_value: 0,
          amount_eligable_for_tax_purposes: 10000
        }
    
        html = Phoenix.View.render_to_string(ApiWeb.ReceiptView, "default.html",
        layout: {ApiWeb.LayoutView, "pdf.html"},
        css: "#{Application.app_dir(:api, "priv/static/css/app.css")}",
        template: template,
        donation: gift,
        organization: Organization.get_organization!(conn.assigns.current_user.organization_id)
        )
    
        new_template = template
        |> Map.put(:template_code, html)

        conn
        |> render("show.json-api", data: new_template)
      {:error, %Ecto.Changeset{} = changeset} -> 
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.ErrorView, "400.json-api", changeset)
    end
  end
end