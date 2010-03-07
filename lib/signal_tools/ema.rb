class EMA < Common
  attr_reader :emas

  def initialize(days, historical_data)
    super(historical_data)
    @emas = get_emas(historical_data.close_prices, days)
  end

  private

  def get_emas(close_prices, days)
    raise if days > close_prices.size
    get_ema_points(close_prices, days)
  end
end
