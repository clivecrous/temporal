require 'temporal'

describe 'One second in other units' do
  it 'is 1/60th of a minute' do
    1.second.should == (1.0/60).minutes
  end
  it 'is 1/3600th of a hour' do
    1.second.should == (1.0/3600).hours
  end
  it 'is 1/86400th of a day' do
    1.second.should == (1.0/86400).days
  end
  it 'is 1/604800th of a week' do
    1.second.should == (1.0/604800).weeks
  end
end

