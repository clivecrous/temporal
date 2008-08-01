require 'temporal'
require 'bacon'

describe 'Temporal math with months' do

  it 'should wrap years while adding' do
    ( Time.local( 1975, 8, 1 ) + 5.months ).should.equal( Time.local( 1976, 1, 1 ) )
  end

end
