module Temporal
  module Mathematics

    def self.units klass
      klass.class_eval do
        alias :temporal_method_missing :method_missing
        def method_missing( method, *arguments, &block )
          return temporal_method_missing( method, *arguments, &block ) unless Temporal::Shift.unit?( method )
          if self.class == Range
            if self.last == self.max
              return Temporal::Shift.new( self.first, method )..Temporal::Shift.new( self.last, method )
            else
              return Temporal::Shift.new( self.first, method )...Temporal::Shift.new( self.last, method )
            end
          end
          Temporal::Shift.new( self, method )
        end
      end
    end

    def self.operators klass
      klass.class_eval do
        begin
          alias :temporal_addition :+
        rescue
          def temporal_addition target
            raise NoMethodError.new( "undefined method `+' for #{self.to_s}:#{self.class.to_s}" )
          end
        end
        def + target
          if target.class == Range and target.first.class == Temporal::Shift
            if target.exclude_end?
              return (target.first + self)..(target.last + self)
            else
              return (target.first + self)...(target.last + self)
            end
          end
          return temporal_addition( target ) unless target.class == Temporal::Shift
          target + self
        end

        begin
          alias :temporal_subtraction :-
        rescue
          def temporal_subtraction target
            raise NoMethodError.new( "undefined method `-' for #{self.to_s}:#{self.class.to_s}" )
          end
        end
        def - target
          return temporal_subtraction( target ) unless target.class == Temporal::Shift
          (-target) + self
        end
      end
    end

  end
end
