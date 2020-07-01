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

    html = Phoenix.View.render_to_string(ApiWeb.ReceiptView, "default.html",
    layout: {ApiWeb.LayoutView, "pdf.html"},
    css: "#{Application.app_dir(:api, "priv/static/css/app.css")}",
    template: template,
    donation: Api.Donation.most_recent_transaction(params.prefix)
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
end