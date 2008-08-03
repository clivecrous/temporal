class Fixnum
  def years
    Temporal::Shift.new( :years, self )
  end
  alias year years
  def months
    Temporal::Shift.new( :months, self )
  end
  alias month months
  def weeks
    Temporal::Shift.new( :weeks, self )
  end
  alias week weeks
  def days
    Temporal::Shift.new( :days, self )
  end
  alias day days
  def hours
    Temporal::Shift.new( :hours, self )
  end
  alias hour hours
  def minutes
    Temporal::Shift.new( :minutes, self )
  end
  alias minute minutes
  def seconds
    Temporal::Shift.new( :seconds, self )
  end
  alias second seconds
end
