require 'temporal'

describe 'One week in other units' do
  it 'is 604800 seconds' do
    1.week.should == 604800.seconds
  end
  it 'is 10080 minutes' do
    1.week.should == 10080.minutes
  end
  it 'is 168 hours' do
    1.week.should == 168.hours
  end
  it 'is 7 days' do
    1.week.should == 7.days
  end
end
