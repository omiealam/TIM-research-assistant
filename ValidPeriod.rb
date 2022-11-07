class ValidPeriod
  # The timeframe defined by the following parameters is inclusive
  attr_accessor :start_month
  attr_accessor :start_year
  attr_accessor :end_month
  attr_accessor :end_year

  def initialize(start_month, start_year, end_month, end_year)
    @start_month = start_month
    @start_year = start_year
    @end_month = end_month
    @end_year = end_year
  end

  def valid_month(month, year)
    if (too_early?(month, year) || too_late?(month, year))
      return false
    else
      return true
    end
  end

  def too_early?(month, year)
    return (month < start_month && year == start_year) || year < start_year
  end

  def too_late?(month, year)
    return (month > end_month && year == end_year) || year > end_year
  end
end 
