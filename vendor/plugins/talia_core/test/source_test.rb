require 'test/unit'
require File.dirname(__FILE__) + "/../lib/talia_core"

# This is to include the main rails configuartion for the test
# TODO: If packaged as a gem, this should work somehow different
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../test/test_helper")


module TaliaCore
  
  # Test the SourceType class
  class SourceTest < Test::Unit::TestCase
    
    N::Namespace.shortcut(:meetest, "http://www.meetest.org/me/")
    
    def setup
      @test_source = Source.new("http://www.test.org/test/")
    end
    
    # Test if a source object can be created correctly
    def test_create
      # rec = SourceRecord.new
      N::Namespace.shortcut(:foaf, "http://www.foaf.org/")
      source = Source.new("http://www.newstuff.org/my_first", N::FOAF.Person, N::FOAF.Foe)
      assert_not_nil(source)
    end
    
    # Checks if the direct object properties work
    def test_object_properties
      @test_source.workflow_state = 2
      @test_source.name = "Foobar"
      assert_equal(2, @test_source.workflow_state)
      assert_equal("Foobar", @test_source.name)
    end
    
    # Checks if the RDF properties work
    def test_rdf_properties
      @test_source.author = "foobar"
      @test_source.relates_to = Source.new("http://www.related.org/")
      @test_source.meetest::predicate = Source.new("http://www.whatever.org")
    end
    
  end
end
  