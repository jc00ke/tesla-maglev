require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Tesla::Finders do

  before do
    @user = User.create(:username => "user", :email => "us@er.com", :status => :active)
    @id = @user.id
  end

  after do
    User.delete_all
  end

  describe "#find" do

    describe "when an id is provided" do

      describe "calling with no arguments" do
        it "should raise" do
          lambda{ User.find }.must_raise ArgumentError
        end
      end

      describe "when an object is found" do

        it "returns the object" do
          User.find(@id).must_equal @user
        end

      end

      describe "when an object is not found" do

        it "raises an error" do
          lambda{ User.find(1) }.must_raise Tesla::Errors::ObjectNotFound
        end

      end
    end

  end

  describe "#all" do

  end

  describe "#exists?" do

  end

  describe "#find_all" do

  end

  describe "#find_or_create_by" do

  end

  describe "#find_or_initialize_by" do

  end

  describe "#first" do

    before do
      @user.status = :active
      @user.save
      @fuser = User.create(:username => "fuzer", :email => "fu@zer.com", :status => :active)
    end

    it "should find the @user" do
      User.find(:first, { :status => :active }).must_be_instance_of User
    end

  end

  describe "#last" do

  end
end
