defmodule Tai.VenueAdapters.OkEx.StreamSupervisor do
  use Supervisor

  alias Tai.VenueAdapters.OkEx.Stream.{
    Connection,
    ProcessAuth,
    ProcessOptionalChannels,
    ProcessOrderBook,
    RouteOrderBooks
  }

  alias Tai.Markets.OrderBook

  @type venue :: Tai.Venue.t()
  @type venue_id :: Tai.Venue.id()
  @type channel :: Tai.Venue.channel()
  @type product :: Tai.Venues.Product.t()
  @type account :: Tai.Venues.Account.t()

  @spec start_link(venue: venue, products: [product], accounts: [account]) ::
          Supervisor.on_start()
  def start_link([venue: venue, products: _, accounts: _] = args) do
    name = venue.id |> to_name()
    Supervisor.start_link(__MODULE__, args, name: name)
  end

  @spec to_name(venue_id) :: atom
  def to_name(venue), do: :"#{__MODULE__}_#{venue}"

  # TODO: Make this configurable
  @endpoint "wss://real.okex.com:8443/ws/v3"

  def init(venue: venue, products: products, accounts: _) do
    credential = venue.credentials |> Map.to_list() |> List.first()

    order_book_children =
      order_book_children(products, venue.quote_depth, venue.broadcast_change_set)

    process_order_book_children = process_order_book_children(products)

    system = [
      {RouteOrderBooks, [venue: venue.id, products: products]},
      {ProcessAuth, [venue: venue.id]},
      {ProcessOptionalChannels, [venue: venue.id]},
      {Connection,
       [
         endpoint: @endpoint,
         venue: venue.id,
         channels: venue.channels,
         credential: credential,
         products: products
       ]}
    ]

    (order_book_children ++ process_order_book_children ++ system)
    |> Supervisor.init(strategy: :one_for_one)
  end

  defp order_book_children(products, quote_depth, broadcast_change_set) do
    products
    |> Enum.map(&OrderBook.child_spec(&1, quote_depth, broadcast_change_set))
  end

  defp process_order_book_children(products) do
    products
    |> Enum.map(fn p ->
      %{
        id: ProcessOrderBook.to_name(p.venue_id, p.venue_symbol),
        start: {ProcessOrderBook, :start_link, [p]}
      }
    end)
  end
end
