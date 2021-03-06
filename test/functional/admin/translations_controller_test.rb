require File.dirname(__FILE__) + '/../../test_helper'

class Admin::TranslationsControllerTest < ActionController::TestCase
  def test_should_redirect_to_active_locale_edit
    login_as :admin
    get :index
    assert_redirected_to edit_admin_translation_path(Locale.active.code)
  end
  
  def test_should_get_edit_page
    login_as :admin
    get :edit, :id => locale
    assert_response :success
    assert_layout :application
    
    assert_select "#languages_picker", /^Pick a language:/
    assert_select "#languages_picker", /Add a translation/
    assert_select "#languages_picker", /Add locale/
    assert_select "#languages_picker" do
      assert_select "select"
    end
    
    assert_select 'form' do
      assert_select '[action=?]', "/admin/translations/#{locale}"
      assert_select 'input[type=?]', 'hidden'
    end
  end
  
  def test_should_update_translations
    login_as :admin
    put :update, params
    # assert_flash_notice "Your translations has been saved"
    assert_redirected_to edit_admin_translation_path(locale, {:page => 2})
  end
  
  uses_mocha 'Admin::TranslationsControllerTest' do
    def test_should_show_error_message_on_failing_update
      ViewTranslation.expects(:update).returns false
      login_as :admin
      put :update, params
      # assert_flash_error "There was some problems"
      assert_redirected_to edit_admin_translation_path(locale, {:page => 2})
    end
  end

  def test_should_destroy_translation
    login_as :admin
    delete :destroy, :id => 1, :locale => 'en-US', :page => "1"
    assert_raise(ActiveRecord::RecordNotFound) { ViewTranslation.find(1) }
    # assert_flash_notice "Your translation has been deleted"
    assert_redirected_to edit_admin_translation_path(locale, {:page => 1})
  end

  private
    def locale
      'en-US'
    end
    
    def translations
      [ { "id" => "1", "tr_key" => "hello", "text" => "Hello!" },
        { "id" => "",  "tr_key" => "rabbit", "text" => "Rabbit" } ]
    end
    
    def params
      { "id" => locale, "page" => "2", "translations" => translations }
    end
end
