require 'temporal'

describe 'One hour in other units' do
  it 'is 3600 seconds' do
    1.hour.should.equal( 3600.seconds )
  end
  it 'is 60 minutes' do
    1.hour.should.equal( 60.minutes )
  end
  it 'is 1/24th of a day' do
    1.hour.should.equal( (1.0/24).days )
  end
  it 'is 1/168th of a week' do
    1.hour.should.equal( (1.0/168).weeks )
  end
end

