defmodule ApiWeb.API.V1.ReceiptStackController do
  use ApiWeb, :controller 

  alias Api.Organization
  alias Api.Organization.ReceiptStack
  
  plug :get_database_prefix

  def stack_for_receipt(conn, %{"receipt_template_id" => id} = params) do
    stack = Organization.get_stack_for_receipt_template(id, params.prefix)
    render(conn, "show.json-api", data: stack)
  end

  def create(conn, %{"data" => data = %{"type" => "receipt-stacks"}} = params) do
    data = data
    |> JaSerializer.Params.to_attributes

    addedData = data
    |> Map.put("current_number", data["starting_number"])

    case Organization.create_receipt_stack(addedData, params.prefix) do
      {:ok, %ReceiptStack{} = receipt_stack} ->
        conn
        |> put_status(:created)
        |> render("show.json-api", data: receipt_stack)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset)
    end
  end
end