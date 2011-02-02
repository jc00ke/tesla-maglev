require File.join(File.dirname(__FILE__), '..', 'spec_helper')

class ::Egg; include Tesla::Model end
class ::Bacon < Struct.new(:type); include Tesla::Model end

describe Tesla::Model do

  describe "persistably included" do
    it "should pass along persistability" do
      assert ::Egg.maglev_persistable?
    end
  end

  describe "instances" do
    before do
      @soggy    = Bacon.new "soggy"
      @crunchy  = Bacon.new "crunchy"
      @chunky   = Bacon.new "chunky"
      @cloggers = [@soggy, @crunchy, @chunky]
    end

    after do
      Bacon.delete_all
    end

    def persist_all
      @cloggers.each{ |bacon| bacon.persist }
    end

    it "should start off empty" do
      assert Bacon.all.empty?
    end

    it "should persist instances" do
      persist_all
      breakfast = Bacon.all
      Bacon.all.count.must_equal 3
      assert @cloggers.all?{ |bacon| breakfast.include?(bacon) }
    end

    describe "count" do
      it "should return number of persistent instances" do
        @cloggers.each_with_index do |bacon, i|
          bacon.persist
          Bacon.count.must_equal(i + 1)
        end
      end
    end

    describe "delete_all" do
      it "should, um, remove all instances" do
        persist_all
        Bacon.delete_all
        Bacon.count.must_equal 0
      end
    end

    it "should support some querying" do
      persist_all
      @cloggers.each do |bacon|
        results = Bacon.select{ |b| b.type[/#{bacon.type}/] }
        results.size.must_equal 1
        assert results.include?(bacon)
      end
    end

    it "should know if it has been persistent" do
      assert @chunky.transient?
      @chunky.persist
      assert @chunky.persistent?
    end

    it "should be desisted" do
      @chunky.desist
      assert @chunky.transient?
    end

    it "should keep include? & not forward it on" do
      @soggy.persist
      assert Bacon.include?(@soggy), "enumberable include? should work"
      assert Bacon.include?(Tesla::Model), "testing module include? should work"
    end
    
  end

  describe "ActiveModel" do

  end
end

describe "ActiveModel" do

  include ActiveModel::Lint::Tests

  class ::Railsy
    include Tesla::Model
    attr_accessor :name, :value
    def to_param
      name if persisted?
    end
  end

  before do
    @foo = Railsy.new :name => 'foo', :value => 13
    @bar = Railsy.new :name => 'bar', :value => 42
    # For the ActiveModel tests
    @model = @foo
  end

  after do
    Railsy.delete_all
  end

  it "should toggle #new_record?" do
    assert @foo.new_record?
    @foo.save
    refute @foo.new_record?
  end

  describe "#new" do
    class SomeClass
      include Tesla::Model
      attr_accessor :name
      def the_name=(da_name)
        @name = "#{da_name}!!!"
      end
    end
    it "should set attrs from a hash" do
      SomeClass.new(:the_name => 'Bob').name.must_equal("Bob!!!")
    end
  end

  describe "#create" do
    it "should set attrs, save & be found" do
      blah = Railsy.create :name => 'blah'
      refute blah.new_record?
      Railsy.find("blah").must_equal blah
    end
  end

  describe "#find" do
    before do
      @foo.save
      @bar.save
    end
    it "should get a persisted model" do
      Railsy.find("foo").must_equal @foo
      Railsy.find("bar").must_equal @bar
    end
    it "should find_by_something" do
      Railsy.find_by_name("foo").must_equal @foo
      Railsy.find_by_value(42).must_equal @bar
    end
  end

  describe "#destroy" do
    it "should remove from the store" do
      @foo.save
      foo = Railsy.find_by_name("foo")
      foo.must_equal @foo
      foo.destroy
      Railsy.find_by_name("foo").must_equal nil
    end
  end

end
