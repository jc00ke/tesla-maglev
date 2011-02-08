require File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper")

describe Tesla::Validations::UniquenessValidator do
  before do
    User.delete_all
    @joe = User.create(:username => "joe", :email => "joe@foo.com")
  end
  describe "when model is new" do
    it "should catch duplicates by a certain attribute" do
      flunk
    end
  end
end

