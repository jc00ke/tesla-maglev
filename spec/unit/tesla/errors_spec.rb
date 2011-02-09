require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Tesla::Errors do

  describe Tesla::Errors::ObjectNotFound do

    describe "attribute readers" do

      it "exists for @identifiers" do
        Tesla::Errors::ObjectNotFound.new(User, "123").must_respond_to :identifiers
      end

      it "exists for @klass" do
        Tesla::Errors::ObjectNotFound.new(User, "234").must_respond_to :klass
      end

    end

    describe "#message" do

      describe "default" do

        before do
          @error = Tesla::Errors::ObjectNotFound.new(User, "345")
        end

        it "contains object not found" do
          @error.message.must_match /^User .* '345' could not be found$/
        end
      end
    end

  end

end
