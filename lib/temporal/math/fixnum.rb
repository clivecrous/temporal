class Fixnum
  def years
    Temporal::Adjuster.new( :years, self )
  end
  alias year years
  def months
    Temporal::Adjuster.new( :months, self )
  end
  alias month months
  def weeks
    Temporal::Adjuster.new( :weeks, self )
  end
  alias week weeks
  def days
    Temporal::Adjuster.new( :days, self )
  end
  alias day days
  def hours
    Temporal::Adjuster.new( :hours, self )
  end
  alias hour hours
  def minutes
    Temporal::Adjuster.new( :minutes, self )
  end
  alias minute minutes
  def seconds
    Temporal::Adjuster.new( :seconds, self )
  end
  alias second seconds
end
