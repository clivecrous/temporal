module Temporal
  module Mathematics

    def self.units klass
      klass.class_eval do
        Temporal::Shift.units.each do |unit|
          if klass == Range
            define_method unit do
              if exclude_end?
                return Temporal::Shift.new( first, unit )...Temporal::Shift.new( last, unit )
              else
                return Temporal::Shift.new( first, unit )..Temporal::Shift.new( last, unit )
              end
            end
          else
            define_method unit do
              Temporal::Shift.new( self, unit )
            end
          end
          define_method "#{unit}s" do
            send(unit)
          end
        end
      end
    end

    def self.negation klass
      klass.class_eval do
        begin
          alias :temporal_negation :-@
        rescue
          def temporal_negation
            raise NoMethodError.new( "undefined method `-@' for #{self.to_s}:#{self.class.to_s}" )
          end
        end
        def -@
          return temporal_negation unless self.class == Temporal::Shift or self.class == Range
          if exclude_end?
            -first...-last
          else
            -first..-last
          end
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
          if target.class == Range
            if self.class == Range
              raise Temporal::Anomaly.new( "Missmatched Range end exclusions" ) if exclude_end? != target.exclude_end?
              if target.exclude_end?
                return (target.first + first)...(target.last + last)
              else
                return (target.first + first)..(target.last + last)
              end
            else
              if target.exclude_end?
                return (target.first + self)...(target.last + self)
              else
                return (target.first + self)..(target.last + self)
              end
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
          return temporal_subtraction( target ) unless target.class == Temporal::Shift or target.class == Range
          (-target) + self
        end
      end
    end

  end
end
