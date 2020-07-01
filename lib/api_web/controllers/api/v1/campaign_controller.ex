defmodule ApiWeb.API.V1.CampaignController do
  use ApiWeb, :controller 

  alias Api.Organization.Campaign
  alias Api.Organization

  plug :get_database_prefix

  def index(conn, params) do
    campaigns = Api.Organization.list_campaigns_for_organization(params.prefix)
    render(conn, "index.json-api", data: campaigns)
  end

  def create(conn, %{"data" => data = %{"type" => "campaigns"}} = params) do
    data = data
    |> JaSerializer.Params.to_attributes
  
    case Organization.create_campaign(data, params.prefix) do
      {:ok, %Campaign{} = campaign} ->
                conn
        |> put_status(:created)
        |> render("show.json-api", data: campaign)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset)
    end
  end

  def campaigns_for_receipt(conn, %{"receipt_template_id" => receipt_id} = params) do
    receipts = Organization.list_campaigns_for_receipt(receipt_id, params.prefix)
    render(conn, "index.json-api", data: receipts)
  end
end