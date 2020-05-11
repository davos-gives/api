defmodule Api.Nationbuilder.Nationbuilder do
  use Tesla, only: [:get]

  def search_organization_donations(client, datetime) do
    Tesla.get(client, "/donations/search", query: [succeeded_since: datetime, limit: 10])
  end

  def search_organization_donations_with_pagination(client, datetime, nonce, token) do
    Tesla.get(client, "/donations/search",
      query: [succeeded_since: datetime, limit: 10, __nonce: nonce, __token: token]
    )
  end

  def organization_donations(client) do
    Tesla.get(client, "/donations", query: [limit: 10])
  end

  def paginated_donations(client, nonce, token) do
    Tesla.get(client, "/donations", query: [__nonce: nonce, __token: token, limit: 100])
  end

  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://davosgives.nationbuilder.com/api/v1"},
      {Tesla.Middleware.Headers,
       [{"Accept", "application/json"}, {"Content-Type", "application/json"}]},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Query, access_token: token}
    ]

    Tesla.client(middleware)
  end
end
