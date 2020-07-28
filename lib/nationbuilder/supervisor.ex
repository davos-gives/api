defmodule Api.Nationbuilder.ServicesSupervisor do
  use DynamicSupervisor

  alias Api.Organization

  def start_link([]) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_workers_for_active_organizations() do
    organizations = Organization.list_organizations()

    children =
      for child <- organizations do
        DynamicSupervisor.start_child(
          __MODULE__,
          {Api.Nationbuilder.TransactionServer, child}
        )
      end
  end

  def start_worker_for_organization(organization) do
    supervisor = DynamicSupervisor.start_child(
      __MODULE__,
      {Api.Nationbuilder.TransactionServer, organization}
    )
  end
end
