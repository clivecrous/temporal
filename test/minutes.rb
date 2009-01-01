require 'temporal'

describe 'One minute in other units' do
  it 'is 60 seconds' do
    1.minute.should == 60.seconds
  end
  it 'is 1/60th of an hour' do
    1.minute.should == (1.0/60).hours
  end
  it 'is 1/1440th of a day' do
    1.minute.should == (1.0/1440).days
  end
  it 'is 1/10080th of a week' do
    1.minute.should == (1.0/10080).weeks
  end
end

