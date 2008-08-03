module Temporal
  module Mathematics

    def self.units klass
      klass.class_eval do
        alias :temporal_method_missing :method_missing
        def method_missing( method, *arguments, &block )
          return temporal_method_missing( method, *arguments, &block ) unless Temporal::Shift.unit?( method )
          Temporal::Shift.new( self, method )
        end
      end
    end

    def self.operators klass
      klass.class_eval do
        alias :temporal_addition :+
        def + target
          return temporal_addition( target ) unless target.class == Temporal::Shift
          target + self
        end

        alias :temporal_subtraction :-
        def - target
          return temporal_subtraction( target ) unless target.class == Temporal::Shift
          (-target) + self
        end
      end
    end

  end
end
