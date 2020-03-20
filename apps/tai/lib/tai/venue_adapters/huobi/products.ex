defmodule Tai.VenueAdapters.Huobi.Products do
  # alias ExHuobi.{Futures, Swap, Spot}
  alias ExHuobi.{Futures}

  def products(venue_id) do
    # with {:ok, future_instruments} <- Futures.Public.instruments(),
    #      {:ok, swap_instruments} <- Swap.Public.instruments(),
    #      {:ok, spot_instruments} <- Spot.Public.instruments() do
    with {:ok, future_instruments} <- Futures.Contracts.get() do
      future_products =
        future_instruments |> Enum.map(&Tai.VenueAdapters.Huobi.Product.build(&1, venue_id))

      # swap_products =
      #   swap_instruments |> Enum.map(&Tai.VenueAdapters.Huobi.Product.build(&1, venue_id))

      # spot_products =
      #   spot_instruments |> Enum.map(&Tai.VenueAdapters.Huobi.Product.build(&1, venue_id))

      # products = future_products ++ swap_products ++ spot_products
      products = future_products

      {:ok, products}
    end
  end

  defdelegate to_symbol(instrument_id), to: Tai.VenueAdapters.Huobi.Product
  # defdelegate from_symbol(symbol), to: Tai.VenueAdapters.Huobi.Product
end
