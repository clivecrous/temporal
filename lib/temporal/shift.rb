module Temporal
  class Shift
    class << self
      def parse string
        return nil unless string =~ /[0-9]+ (second|minute|hour|day|week|month|year)s?/
        split = string.split
        return Temporal::Shift.new( split[1], split[0].to_i )
      end
    end
    attr_reader :adjuster
    attr :amount
    def initialize adjuster, amount
      adjuster = adjuster.to_s
      adjuster += "s" unless adjuster[-1].chr == 's'
      @adjuster = "add_#{adjuster}".to_sym
      @amount = amount
    end
    def + time
      return time.send( @adjuster, @amount ) if time.class == Time
      if time.class == Temporal::Shift
        if @adjuster == time.adjuster
          @amount += time.amount
          return self
        else
          throw "Cannot add differing adjusters"
        end
      end
      throw "Cannot add #{time.class} class"
    end
    def - time
      return time.send( @adjuster, -@amount ) if time.class == Time
      if time.class == Temporal::Shift
        if @adjuster == time.adjuster
          @amount -= time.amount
          return self
        else
          throw "Cannot subtract differing adjusters"
        end
      end
      throw "Cannot subtract #{time.class} class"
    end
  end
end
