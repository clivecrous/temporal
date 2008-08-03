class Range
  def + something
    if something.class == Temporal::Shift
      new_first = first + something
      new_last = last + something
      if last == max
        new_first..new_last
      else
        new_first...new_last
      end
    else
      super
    end
  end
  def - something
    if something.class == Temporal::Shift
      new_first = first - something
      new_last = last - something
      if last == max
        new_first..new_last
      else
        new_first...new_last
      end
    else
      super
    end
  end
end
