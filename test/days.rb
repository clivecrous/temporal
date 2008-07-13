require 'temporal'
require 'bacon'

describe 'Temporal math with days' do

  before do
    @context = Time.local( 1975, 05, 13, 01, 23, 45)
  end

  it 'should add a day' do
    ( @context + 1.day ).should.equal( Time.local( 1975, 05, 14, 01, 23, 45) )
  end

  it 'should subtract a day' do
    ( @context - 1.day ).should.equal( Time.local( 1975, 05, 12, 01, 23, 45) )
  end

  it 'should add days' do
    ( @context + 2.days ).should.equal( Time.local( 1975, 05, 15, 01, 23, 45) )
  end

  it 'should subtract days' do
    ( @context - 2.days ).should.equal( Time.local( 1975, 05, 11, 01, 23, 45) )
  end

  it 'should wrap months while adding' do
    ( Time.local( 1975, 05, 31, 01, 23, 45 ) + 1.day ).should.equal( Time.local( 1975, 06, 1, 01, 23, 45 ) )
  end

  it 'should wrap months while subtracting' do
    ( Time.local( 1975, 05, 1, 01, 23, 45 ) - 1.day ).should.equal( Time.local( 1975, 04, 30, 01, 23, 45 ) )
  end

  it 'should wrap years while adding' do
    ( Time.local( 1975, 12, 31, 01, 23, 45 ) + 1.day ).should.equal( Time.local( 1976, 01, 01, 01, 23, 45 ) )
  end

  it 'should wrap years while subtracting' do
    ( Time.local( 1975, 01, 01, 01, 23, 45 ) - 1.day ).should.equal( Time.local( 1974, 12, 31, 01, 23, 45 ) )
  end

end
