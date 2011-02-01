require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Tesla::Model do

  describe "persistably included" do
    before do
      class ::Egg; include Tesla::Model end
    end

    it "should pass along persistability" do
      ::Egg.maglev_persistable?.must_equal true
    end
  end
end
