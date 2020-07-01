defmodule ApiWeb.LayoutView do
  use ApiWeb, :view


  def primary_colour(template, params) do
    cond do
      params == ApiWeb.ReceiptView ->
        template.primary_colour || "#e5ad23"
      true ->
         "#e5ad23"
    end
  end

  def secondary_colour(template, params) do
    cond do
      params == ApiWeb.ReceiptView ->
        template.secondary_colour || "#e5ad23"
      true ->
        "#411E82"
    end
  end

  def tertiary_colour(template, params) do
    cond do
        params == ApiWeb.ReceiptView ->
          template.tertiary_colour || "#e5ad23"
      true ->
        "#BB8B0E"
    end
  end

  def quaternary_colour(template, params) do
    cond do
      params == ApiWeb.ReceiptView ->
        template.quaternary_colour || "#e5ad23"
      true ->
        "#FFFFFF"
    end
  end

  def quinary_colour(template, params) do
    cond do
      params == ApiWeb.ReceiptView ->
        template.quinary_colour || "#e5ad23"
      true ->
        "#666271"
    end
  end

  def font(template, params) do
    cond do
      params == ApiWeb.ReceiptView ->
        template.font || "Open Sans"
      true ->
        "Open Sans"
    end
  end
end
