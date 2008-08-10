module Temporal
  class Shift

    include Comparable

    MINUTE = 60
    HOUR = MINUTE * 60
    DAY = HOUR * 24
    WEEK = DAY * 7

    YEAR = 12

    MAX_MONTH_DAY = %w|31 0 31 30 31 30 31 31 30 31 30 31|.map{|n|n.to_i} # Don't worry about February

    attr_accessor :seconds
    attr_accessor :months

    def initialize amount, unit
      unless self.class.unit?( unit )
        raise Temporal::Anomaly.new( "Bad #{self.class}.unit type of `#{unit}' given" )
      end

      @seconds = 0
      @months = 0

      unit = unit.to_s.downcase
      unit.chop! if unit[-1..-1] == 's'
      unit = unit.to_sym

      case unit
      when :second
        @seconds = amount
      when :minute
        @seconds = amount * MINUTE
      when :hour
        @seconds = amount * HOUR
      when :day
        @seconds = amount * DAY
      when :week
        @seconds = amount * WEEK
      when :month
        @months = amount
      when :year
        @months = amount * YEAR
      else
        raise Temporal::Anomaly.new( "Internal Error, failed to catch bad #{self.class}.unit type of `#{unit}' given" )
      end
    end

    def <=> target
      return 1 if @months > target.months
      return -1 if @months < target.months
      return 1 if @seconds > target.seconds
      return -1 if @seconds < target.seconds
      0
    end

    def self.units
      %w|second minute hour day week month year|
    end

    def self.unit? unit
      (unit.to_s.strip.downcase =~ /^(#{units.join('|')})s?$/) != nil
    end

    def + to_be_added

      if to_be_added.class == self.class
        result_instance = self.class.new( @seconds + to_be_added.seconds, :seconds )
        result_instance.months = @months + to_be_added.months
        return result_instance
      end

      if to_be_added.class == Time
        new_time = (to_be_added + @seconds).localtime
        new_year = new_time.year+(((new_time.month-1)+months)/12)
        new_month = (((new_time.month-1)+months)%12)
        new_day = new_time.day
        if new_month == 1
          if (new_year%4 == 0 and new_year%100 != 0) or new_year%400 == 0
            max_mday = 29
          else
            max_mday = 28
          end
        else
          max_mday = MAX_MONTH_DAY[ new_month ];
        end
        new_day = max_mday if new_day > max_mday
        return Time.local( new_year, new_month+1 , new_day, new_time.hour, new_time.min, new_time.sec, new_time.usec )
      end

      if to_be_added.class == Range
        new_first = self + to_be_added.first
        new_last = self + to_be_added.last
        if to_be_added.exclude_end?
          return new_first...new_last
        else
          return new_first..new_last
        end
      end

      raise Temporal::Anomaly.new( "Unable to add #{self.class} to instances of `#{to_be_added.class}'" )
    end

    def -@
      negated = self.class.new( -@seconds, :seconds )
      negated.months = -@months
      return negated
    end

    def - to_be_subtracted
      begin
        self + ( -to_be_subtracted )
      rescue Exception => e
        raise Temporal::Anomaly.new( "Unable to subtract an instance of #{to_be_subtracted.class} from #{self.class}" )
      end
    end

    def to_s
      result = {}

      result[:months] = @months

      result[:years] = (result[:months]/12).truncate
      result[:months] = result[:months] - ( result[:years] * 12 )
      result[:months] = result[:months].truncate if result[:months].modulo(1) == 0

      result[:seconds] = @seconds

      result[:weeks] = (result[:seconds] / WEEK).truncate
      result[:seconds] = result[:seconds] - (result[:weeks] * WEEK)
      result[:days] = (result[:seconds] / DAY).truncate
      result[:seconds] = result[:seconds] - (result[:days] * DAY)
      result[:hours] = (result[:seconds] / HOUR).truncate
      result[:seconds] = result[:seconds] - (result[:hours] * HOUR)
      result[:minutes] = (result[:seconds] / MINUTE).truncate
      result[:seconds] = result[:seconds] - (result[:minutes] * MINUTE)
      result[:seconds] = result[:seconds].truncate if result[:seconds].modulo(1) == 0

      result = Hash[ *result.select{|unit, amount| amount != 0 }.flatten ]

      string = ""

      %w|years months weeks days hours minutes seconds|.each do |unit|
        unit = unit.to_sym
        next unless result.has_key?( unit )
        string += "#{result[ unit ]} #{unit}"
        string.chop! if result[ unit ].abs == 1
        result.delete( unit )
        break if result.size == 0
        if result.size == 1
          string += " and "
        else
          string += ", "
        end
      end

      string
    end

  end

end
