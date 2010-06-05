class EMA < Common
  attr_reader :emas

  def initialize(ticker, period, historical_data)
    super(ticker, historical_data)
    @emas = get_emas(period)
  end

  private

  def get_emas(period)
    get_ema_points(period, @close_prices)
  end
end
