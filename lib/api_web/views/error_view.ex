defmodule ApiWeb.ErrorView do
  use ApiWeb, :view

  def render("400.json-api", %Ecto.Changeset{} = changeset) do
    JaSerializer.EctoErrorSerializer.format(changeset)
  end

  def render("401.json-api", %{detail: detail}) do
    %{status: 401, title: "Unauthorized", detail: detail}
    |> JaSerializer.ErrorSerializer.format()
  end

  def render("403.json-api", %{}) do
    %{status: 403, title: "Forbidden", detail: "User does not have access to edit this resource"}
    |> JaSerializer.ErrorSerializer.format()
  end

  def render("404.json-api", assigns) do
    %{title: "Page not found", status: 404}
    |> JaSerializer.ErrorSerializer.format()
  end

  def render("500.json-api", assigns) do
    %{title: "Internal server error", status: 500}
    |> JaSerializer.ErrorSerializer.format()
  end

  def template_not_found(_template, assigns) do
    render("500.json-api", assigns)
  end
end
