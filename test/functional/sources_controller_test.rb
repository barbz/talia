require File.dirname(__FILE__) + '/../test_helper'
require 'sources_controller'

# Re-raise errors caught by the controller.
class SourcesController; def rescue_action(e) raise e end; end

class SourcesControllerTest < Test::Unit::TestCase
  fixtures :active_sources
  
  N::Namespace.shortcut(:myns, "http://myns.org/")
  
  def setup
    @controller = SourcesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @source_name      = 'something'
    @unexistent_name  = 'somewhat'
  end

  def test_index
    get :index, {}
    assert_response :success
  end
  
  # SHOW
  def test_show_without_the_source_name
    # This will raise an exception, cause the route called is:
    #   sources/show
    # It tries to find a source with the name 'show'
    # This behavior it's ok, cause we cannot never request this route.
    assert_raise(ActiveRecord::RecordNotFound) { get :show, {} }
  end
  
  def test_show_with_unexistent_source_name
    assert_raise(ActiveRecord::RecordNotFound) { get :show, {:id => @unexistent_name} }
  end
  
  def test_show_with_wrong_http_verbs
    post    :show, {:id => @source_name}
    assert_response :success
    put     :show, {:id => @source_name}
    assert_response :success
    delete  :show, {:id => @source_name}
    assert_response :success
  end
  
  def test_show
    get :show, {:id => @source_name}
    assert_response :success
    assert_layout :application

    # TODO assert template elements
  end
  
  # SHOW_ATTRIBUTE
  def test_show_attribute_without_thw_source_name
    assert_raise(ActiveRecord::RecordNotFound) { get :show_attribute, {} }
  end
  
  def test_show_attribute_with_unexistent_source_name
    assert_raise(ActiveRecord::RecordNotFound) { get :show_attribute, {:source_id => @unexistent_name} }
  end
  
  def test_show_attribute_with_wrong_http_verbs
    post   :show_attribute, {:source_id => @source_name, :attribute => 'name'}
    assert_response :success
    put    :show_attribute, {:source_id => @source_name, :attribute => 'name'}
    assert_response :success
    delete :show_attribute, {:source_id => @source_name, :attribute => 'name'}
    assert_response :success
  end
  
  def test_show_attribute
    assert_routing("sources/#{@source_name}/name",
                  {:controller => 'sources', :action => 'show_attribute', 
                    :source_id => 'something', :attribute => 'name', 
                    :namespace => nil, :path_prefix => '/sources/:source_id', 
                    :name_prefix => "source_"})
    get :show_attribute, {:source_id => @source_name, :attribute => 'name'}
    assert_response :success
  end
  
  # SHOW_RDF_PREDICATE
  def test_show_rdf_predicate_with_wrong_params
    # empty params
    assert_raise(ActiveRecord::RecordNotFound) { get :show_rdf_predicate, {} }
    
    # unexistent source
    params = {:id => @unexistent_name, :namespace => 'default', :predicate => 'pr'}
    assert_raise(ActiveRecord::RecordNotFound) { get :show_rdf_predicate, params}
    
    # unexistent namespace
    source = TaliaCore::Source.find(@source_name)
    source.myns::predicate << 'some value'
    params = params.merge(:id => @source_name, :namespace => 'foo')
    assert_raise(ArgumentError) { get :show_rdf_predicate, params }
    
    # unexistent predicate
    params = params.merge(:namespace => 'myns')
    get :show_rdf_predicate, params
  end
    
  def test_show_rdf_predicate
    source = TaliaCore::Source.find(@source_name)
    source.foaf::friend << 'a friend'
    params = {:id => @source_name, :namespace => 'foaf', :predicate => 'friend'}
    get :show_rdf_predicate, params
    assert_response :success
  end
end