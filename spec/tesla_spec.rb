require File.join(File.dirname(__FILE__), 'spec_helper')

describe Tesla do
  it "should be persistable" do
    Tesla.maglev_persistable?.must_equal true
  end
end

