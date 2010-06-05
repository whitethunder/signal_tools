class AverageDirectionalIndex < Common
  attr_reader :average_directional_index

  def initialize(from_date, days, historical_data)
    super(historical_data)
    average_directional_indexes(from_date, days)
  end

  def average_directional_indexes(from_date, days)

  end

  private

  dates = dates_for_period(from_date, days)
  (0...(dates.size)).each do |index|
    @average_directional_index[dates[index]] =
  end

  def get_plus_di(date, period)
    100 * get_ema_points(date, period)
  end

  def get_minus_di
  end

  def get_plus_dm(date)
    up_move = get_up_move(date)
    down_move = get_down_move(date)
    (up_move > down_move && up_move > 0) ? up_move : 0
  end

  def get_minus_dm(date)
    up_move = get_up_move(date)
    down_move = get_down_move(date)
    (down_move > up_move && down_move > 0) ? down_move : 0
  end

  # Up move is today_high - yesterday_high
  def get_up_move(date)
    @date_prices[date][High] - @date_prices[(Date.parse(date) - 1).strftime][High]
  end

  # Down move is yesterday_low - today_low
  def get_down_move(date)
    @date_prices[(Date.parse(date) - 1).strftime][Low] - @date_prices[date][Low]
  end
end

plus_dm = (up_move > down_move && up_move > 0) ? up_move : 0
minus_dm = (down_move > up_move && down_move > 0) ? down_move : 0

plus_di = 100 * ema_plus_dm / ema_atr
minus_di = 100 * ema_minus_dm / ema_atr
adx = 100 * ema(abs((plus_di - minus_di) / (plus_di + minus_di)))


To calculate +DI and -DI, one needs price data consisting of high, low, and closing prices each period (typically each day). One first calculates the Directional Movement (+DM and -DM):
UpMove = Today's High − Yesterday's High
DownMove = Yesterday's Low − Today's Low
if UpMove > DownMove and UpMove > 0, then +DM = UpMove, else +DM = 0
if DownMove > UpMove and DownMove > 0, then -DM = DownMove, else -DM = 0
After selecting the number of periods (Wilder used 14 days originally), +DI and -DI are:
+DI = 100 times exponential moving average of +DM divided by Average True Range
-DI = 100 times exponential moving average of -DM divided by Average True Range
The exponential moving average is calculated over the number of periods selected, and the average true range is an exponential average of the true ranges. Then:
ADX = 100 times the exponential moving average of the Absolute value of (+DI − -DI) divided by (+DI + -DI)
