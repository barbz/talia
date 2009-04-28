require 'cgi'
require 'uri'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  
  def iip_flash_viewer(facsimile, height = 400, width = 400, klass='iipviewer')
    if(facsimile.blank)
      render :partial => 'shared/facsimile_blank', :locals => { :div_class => klass }
    else
      iip_data = get_iip_data_for_facs(facsimile)
      return "No iip data for #{facsimile.uri}" unless(iip_data)
      render :partial => 'shared/iip_flash_viewer', :locals => {
        :image_path => iip_data.get_iip_root_file_path,
        :height => height.to_s,
        :width => width.to_s,
        :element_id => "iip_viewer_#{rand 10E16}", # Random name so that multiple instances can be used
        :div_class => klass
      }
    end
  end

  # list of institutions to be shown in the footer
  def institutions
    institutions = TaliaCore::CONFIG['institutions']
  end

  # overseer link in the footer
  def overseers_footer_link
    overseers = TaliaCore::CONFIG['overseers']
    @overseer = []
    overseers.each do |link, title|
      @overseer << titled_link(title, link)
    end
    @overseer
  end


  # The (translated) material description for the element
  def material_description(element)
    t(:"talia.material_descriptions.#{element.uri.local_name.underscore}")
  end
  
  # Gets the translated type description
  def type_description(type)
    t(:"talia.types.#{type.local_name.underscore}_description")
  end
  
  # Gets the translated name of the given element (category or series)
  def translate_name_for(element)
    return nil unless(element.name)
    t(:"talia.names.#{element.class.name.underscore}.#{element.name.underscore}")
  end

  # Gets the translated name of the given edition
  def translate_edition_name(edition, in_place_allowed = true)
    title = edition_title(edition)
    t(:"talia.edition.#{title.underscore.downcase}", in_place_allowed)
  end
  
  # To include the customization template with the given name
  def load_customization(template, options = {})
    render(options.merge(:partial => "custom/#{template}"))
  end
  
  # Returns the title for the whole page. This returns the value
  # set in the controller, or a default value
  def page_title
    @page_title || TaliaCore::SITE_NAME
  end
  
  # Returns the subtitle for the page. See page_title
  def page_subtitle
    @page_subtitle ? @page_subtitle : "Let's discover what's out there"
  end
  
  # Creates a link to the given source
  def source_link(text, source)
    link_to(text, :controller => 'sources', :action => 'show', :id => source.uri.local_name)
  end
  
  def stylesheet(*file_names)
    file_names.each {|fn| content_for :stylesheet, stylesheet_link_tag(fn.to_s)}
    nil
  end
  
  # Helper to get the short name of a source
  def short_name(source) 
    assit_kind_of(TaliaCore::Source, source)
    shortname = source.talias::shortname
    if(shortname && shortname.size > 0)
      # get the first short name
      shortname = shortname[0]
    else
      shortname = source.uri.local_name
    end
    
    shortname
  end
  
  # Returns true if the given property has at least one value on the given
  # Source.
  def has_property?(property)
    property && property.size > 0
  end
  
  # Show each <tt>flash</tt> status (<tt>:notice</tt>, <tt>:error</tt>) only if it's present.
  def show_flash
    [:notice, :error].collect do |status|
      %(<div id="#{status}">#{flash[status]}</div>) unless flash[status].nil?
    end
  end

  # Insert the google analytics script code, if an id is set for the
  # installation
  def google_analytics
    google_id = TaliaCore::CONFIG['google_analytics_id']
    return unless(google_id)
    render(:partial => 'shared/google_analytics', :locals => { :google_analytics_id => google_id })
  end

  # Privacy note on Google analytitcs. Will be empty unless analytics is enabled
  def google_privacy_note
    return '' unless(TaliaCore::CONFIG['google_analytics_id'])
    result = t(:'talia.global.google_notice')
    result << ' '
    result << link_to(t(:'talia.global.privacy_policy'), 'http://www.google.com/intl/en/privacy_highlights.html')
    result
  end
  
  # Show the logout box if the user is loggedin.
  # TODO: in future should handle even the login link.
  def login_box
    %(<div id="login_box">#{link_to("Logout", logout_path)}</div>) if logged_in?
  end
  
  # Get a link that contains the (thumbnail) image for the iip data record
  # of the first manifestation of the given expression card. The img_options
  # are added to the image tag.
  def thumb_link(element, img_options = {})
    url = element.uri.to_s
    title = element.uri.local_name
    
    # If this is a book we need to use the first page as a thumbnail
    data_element = if(element.is_a?(TaliaCore::Book))
      element.ordered_pages.elements.detect { |page| (page && !page_blank?(page)) }
    else
      element
    end
    
    # Try to get the iip data record for the manifestation of the element
    iip_data = get_iip_data_for_card(data_element)
    return titled_link(url, empty_thumb(:alt => title), title) unless(iip_data)

    img_options = { :alt => title }.merge(img_options)
    img_tag = talia_image_tag(iip_data, img_options)
    

    titled_link(url, img_tag, title)
  end
  
  def talia_image_tag(image, options = {})
    static_prefix = TaliaCore::CONFIG['static_data_prefix']
    if(!static_prefix || static_prefix == '' || static_prefix == 'disabled')
      image_tag(url_for(:controller => 'source_data', :action => 'show', :id => image.id), options)
    else
      static_url = image.static_path
      image_tag(static_url, options)
    end
  end

  def empty_thumb(options)
    image_tag('/images/empty_thumb.gif', options)
  end
  
  def titled_link (url, text, title=nil)
    title ||= ''
    title = CGI::escape(title)
    %(<a href="#{unescape_link(url.to_s)}" title="#{title}">#{text}</a>)
  end
  
  def action_name
    controller.action_name
  end
  
  private


  def facsimile_for(expression_card)
    expression_card.manifestations(TaliaCore::Facsimile).first
  end

  def page_blank?(page)
    blank = facsimile_for(page).blank
    (blank != nil) && (blank != 'false')
  end

  def get_iip_data_for_facs(facsimile)
    iip_data = TaliaCore::DataTypes::IipData.find(:first, :conditions => { :source_id => facsimile.id })
    iip_data
  end

  def get_iip_data_for_card(expression_card)
    facsimile = facsimile_for(expression_card)
    return nil unless(facsimile)
    get_iip_data_for_facs(facsimile)
  end

  def edition_title(edition)
    assit_kind_of(TaliaCore::Catalog, edition)
    title = edition.title
    assit(title)
    return nil unless(title)
    title
  end

  # Create a locale-sensitve URL by replacing "LANG" in the current string with
  # the current language code
  def locale_uri(string)
    string.gsub(/LANG/, Locale.language_code)
  end
  
end
