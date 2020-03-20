defmodule Tai.VenueAdapters.Huobi do
  alias Tai.VenueAdapters.Huobi.{
    StreamSupervisor,
    Products
    # Accounts
    # Positions,
    # MakerTakerFees,
    # CreateOrder,
    # CancelOrder
  }

  @behaviour Tai.Venues.Adapter

  def stream_supervisor, do: StreamSupervisor
  defdelegate products(venue_id), to: Products
  # defdelegate accounts(venue_id, credential_id, credentials), to: Accounts
  def accounts(_venue_id, _credential_id, _credentials), do: {:error, :not_implemented}
  # defdelegate maker_taker_fees(venue_id, credential_id, credentials), to: MakerTakerFees
  def maker_taker_fees(_venue_id, _credential_id, _credentials), do: {:error, :not_implemented}
  # defdelegate positions(venue_id, credential_id, credentials), to: Positions
  def positions(_venue_id, _credential_id, _credentials), do: {:error, :not_implemented}
  # defdelegate create_order(order, credentials), to: CreateOrder
  def create_order(_order, _credentials), do: {:error, :not_implemented}
  def amend_order(_order, _attrs, _credentials), do: {:error, :not_supported}
  def amend_bulk_orders(_orders_with_attrs, _credentials), do: {:error, :not_supported}
  # defdelegate cancel_order(order, credentials), to: CancelOrder
  def cancel_order(_order, _credentials), do: {:error, :not_implemented}
end
