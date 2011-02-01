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
end
