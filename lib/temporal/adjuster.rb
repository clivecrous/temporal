module Temporal
  class Adjuster
    class << self
      def parse string
        return nil unless string =~ /[0-9]+ (second|minute|hour|day|week|month|year)s/
        split = string.split
        return Temporal::Adjuster.new( split[1], split[0].to_i )
      end
    end
    attr_reader :adjuster
    attr :amount
    def initialize adjuster, amount
      @adjuster = "add_#{adjuster.to_s}".to_sym
      @amount = amount
    end
    def + time
      return time.send( @adjuster, @amount ) if time.class == Time
      if time.class == Temporal::Adjuster
        if @adjuster == time.adjuster
          @amount += time.amount
          return self
        else
          p '-'*50
          p self
          p time
          p '-'*50
          throw "Cannot add differing adjusters"
        end
      end
      throw "Cannot add #{time.class} class"
    end
    def - time
      return time.send( @adjuster, -@amount ) if time.class == Time
      if time.class == Temporal::Adjuster
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
