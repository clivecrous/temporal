[Fixnum,Float,Range].each do |klass|
  Temporal::Mathematics.units( klass )
  Temporal::Mathematics.operators( klass )
end

[Time].each do |klass|
  Temporal::Mathematics.operators( klass )
end
