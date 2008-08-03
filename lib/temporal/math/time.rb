class Time
  MAX_MDAY = %w|31 30 31 30 31 30 31 31 30 31 30 31|.map{|n|n.to_i}
  alias alias_temporal_add +
  def + value
    if value.class == Temporal::Adjuster
      value + self
    else
      alias_temporal_add( value )
    end
  end
  alias alias_temporal_subtract -
  def - value
    if value.class == Temporal::Adjuster
      value - self
    else
      alias_temporal_subtract( value )
    end
  end
  def add_seconds seconds
    self + seconds
  end
  def add_minutes minutes
    add_seconds( minutes*60 )
  end
  def add_hours hours
    add_minutes( hours * 60 )
  end
  def add_days days
    add_hours( days * 24 )
  end
  def add_weeks weeks
    add_days( weeks * 7 )
  end
  def add_months months
    tm = localtime
    new_year = tm.year+(((tm.month-1)+months)/12)
    new_month = (((tm.month-1)+months)%12)
    new_day = tm.day
    if new_month == 1
      if (new_year%4 == 0 and new_year%100 != 0) or new_year%400 == 0
        max_mday = 29
      else
        max_mday = 28
      end
    else
      max_mday = MAX_MDAY[ new_month ];
    end
    new_day = max_mday if new_day > max_mday
    Time.local( new_year, new_month+1 , new_day, tm.hour, tm.min, tm.sec, tm.usec )
  end
  def add_years years
    add_months( years*12 )
  end
end
