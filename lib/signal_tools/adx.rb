class ADX < Common
  attr_reader :adxs

  def initialize(from_date, period, historical_data)
    super(ticker, historical_data)
    average_directional_indexes(period, historical_data)
  end

  private

  def average_directional_indexes(period, data)
    plus_dm_ema = get_ema_points(period, get_plus_dm(data))
    minus_dm_ema = get_ema_points(period, get_minus_dm(data))
    atrs = average_true_ranges(period, data)
    Array.truncate_to_shortest!(plus_dm_ema, minus_dm_ema, atrs)
    plus_di = get_plus_di(plus_dm_ema, atrs)
    minus_di = get_minus_di(minus_dm_ema, atrs)
    @adxs = calculate_adx(plus_di, minus_di, period)
  end

  def calculate_adx(plus_di, minus_di, period)
#ADX = 100 times the exponential moving average of the Absolute value of (+DI − -DI) divided by (+DI + -DI)
    index = 0
    absolute_values = []
#    get_ema_points(period)
  end

  def get_plus_di(plus_dm_ema, atrs)
    index = 0
    plus_di = []
    while index < plus_dm_ema.size
      plus_di << 100 * plus_dm_ema[index] / atrs[index]
      index += 1
    end
    plus_di
  end

  def get_minus_di(minus_dm_ema, atrs)
    index = 0
    minus_di = []
    while index < minus_dm_ema.size
      minus_di << 100 * minus_dm_ema[index] / atrs[index]
      index += 1
    end
    minus_di
  end

  def get_plus_dm(data)
    plus_dm = []
    data.each_cons(2) do |two_days|
      up_move = get_up_move(two_days.first, two_days.last)
      down_move = get_down_move(two_days.first, two_days.last)
      plus_dm << ((up_move > down_move && up_move > 0) ? up_move : 0)
    end
    plus_dm
  end

  def get_minus_dm(data)
    minus_dm = []
    data.each_cons(2) do |two_days|
      up_move = get_up_move(two_days.first, two_days.last)
      down_move = get_down_move(two_days.first, two_days.last)
      minus_dm << ((down_move > up_move && down_move > 0) ? down_move : 0)
    end
    minus_dm
  end

  # Up move is today_high - yesterday_high
  def get_up_move(today, yesterday)
    today[High] - yesterday[High]
  end

  # Down move is yesterday_low - today_low
  def get_down_move(today, yesterday)
    yesterday[Low] - today[Low]
  end
end

#plus_dm = (up_move > down_move && up_move > 0) ? up_move : 0
#minus_dm = (down_move > up_move && down_move > 0) ? down_move : 0

#plus_di = 100 * ema_plus_dm / ema_atr
#minus_di = 100 * ema_minus_dm / ema_atr
#adx = 100 * ema(abs((plus_di - minus_di) / (plus_di + minus_di)))


#To calculate +DI and -DI, one needs price data consisting of high, low, and closing prices each period (typically each day). One first calculates the Directional Movement (+DM and -DM):
#UpMove = Today's High − Yesterday's High
#DownMove = Yesterday's Low − Today's Low
#if UpMove > DownMove and UpMove > 0, then +DM = UpMove, else +DM = 0
#if DownMove > UpMove and DownMove > 0, then -DM = DownMove, else -DM = 0
#After selecting the number of periods (Wilder used 14 days originally), +DI and -DI are:
#+DI = 100 times exponential moving average of +DM divided by Average True Range
#-DI = 100 times exponential moving average of -DM divided by Average True Range
#The exponential moving average is calculated over the number of periods selected, and the average true range is an exponential average of the true ranges. Then:
#ADX = 100 times the exponential moving average of the Absolute value of (+DI − -DI) divided by (+DI + -DI)
