require 'temporal'

describe 'Temporal math with months' do

  it 'should wrap years while adding' do
    ( Time.local( 1975, 8, 1 ) + 5.months ).should.equal( Time.local( 1976, 1, 1 ) )
  end

  it 'should not wrap years while adding 1 month to november' do
    ( Time.local( 1975, 11, 1 ) + 1.month ).should.equal( Time.local( 1975, 12, 1 ) )
  end

end
