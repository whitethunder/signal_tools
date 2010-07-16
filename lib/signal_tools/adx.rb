class ADX < Common
  attr_reader :adxs

  def initialize(from_date, period, historical_data)
    super(ticker, historical_data)
    average_directional_indexes(period, historical_data)
  end

  private

  def average_directional_indexes(period, data)
    dxs = get_dxs(get_plus_di(period, data), get_minus_di(period, data))
    @adxs = get_ema_points(period, dxs, :wilder)
  end

  def get_dxs(plus_dis, minus_dis)
    Array.truncate_to_shortest!(plus_dis, minus_dis)
    differences, sums = [], []
    index = 0
    while index < plus_dis.size
      differences << (plus_dis[index] - minus_dis[index]).abs
      sums << (plus_dis[index] + minus_dis[index])
      index += 1
    end
    get_quotients(differences, sums)
  end

  def get_plus_di(period, data)
    plus_dms = get_plus_dm(data)
    plus_dm_sums = get_period_sum_ema(period, plus_dms)
    true_range_sums = get_period_sum_ema(period, get_true_ranges(data))
    get_quotients(plus_dm_sums, true_range_sums)
  end

  def get_minus_di(period, data)
    minus_dms = get_minus_dm(data)
    minus_dm_sums = get_period_sum_ema(period, minus_dms)
    true_range_sums = get_period_sum_ema(period, get_true_ranges(data))
    get_quotients(minus_dm_sums, true_range_sums)
  end

  def get_quotients(first, second)
    Array.truncate_to_shortest!(first, second)
    index = 0
    quotients = []
    while index < first.size
      quotients << first[index] / second[index]
      index += 1
    end
    quotients
  end

  def get_plus_dm(data)
    plus_dm = []
    data.each_cons(2) do |two_days|
      up_move = get_up_move(two_days.last, two_days.first)
      down_move = get_down_move(two_days.last, two_days.first)
      plus_dm << ((up_move > down_move) ? up_move : 0)
    end
    plus_dm
  end

  def get_minus_dm(data)
    minus_dm = []
    data.each_cons(2) do |two_days|
      up_move = get_up_move(two_days.last, two_days.first)
      down_move = get_down_move(two_days.last, two_days.first)
      minus_dm << ((down_move > up_move) ? down_move : 0)
    end
    minus_dm
  end

  # Up move is today_high - yesterday_high
  def get_up_move(today, yesterday)
    diff = today[High] - yesterday[High]
    diff > 0 ? diff : 0
  end

  # Down move is yesterday_low - today_low
  def get_down_move(today, yesterday)
    diff = yesterday[Low] - today[Low]
    diff > 0 ? diff : 0
  end
end
