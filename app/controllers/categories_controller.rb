class CategoriesController < ApplicationController

  layout 'simple_page'
  
  def show
    cat_uri = N::LOCAL + request.request_uri[1..-1]
    raise(ArgumentError, "Unknow Category #{cat_uri}") unless(TaliaCore::Category.exists?(cat_uri))
    
    @category = TaliaCore::Category.find(cat_uri)
    @all_categories = TaliaCore::Category.find(:all)
    @path = [ { :text => t(@category.name) } ]
    @title = t(:'talia.global.category') + " | #{t(@category.name)}"
    @subtitle = t(:'talia.global.category') 
  end
  
  def advanced_search
    @path = []
    
    # if user has clicked on seach button, execute search method
    unless params[:advanced_search_submission].nil?
      # collect data to post
      data = {'search_type[]' => params[:search_type]}
      
      # check if words field is empty 
      if params[:title_words]
        data['title_words[]'] = params[:title_words]
      end
      
      # check if words field is empty 
      if params[:abstract_words]
        data['abstract_words[]'] = params[:abstract_words]
      end
      
      # check if words field is empty 
      if params[:keyword]
        data['keyword[]'] = params[:keyword]
      end
      
      # load exist options.
      exist_options = TaliaCore::CONFIG['exist_options']
      raise "eXist configuration not found." if exist_options.nil?
      
      # execute post to servlet
      resp = Net::HTTP.post_form URI.parse(URI.join(exist_options['server_url'],"/#{exist_options['community']}/Search").to_s), data
      
      # error check
      raise "#{resp.code}: #{resp.message}" unless resp.kind_of?(Net::HTTPSuccess)
     
      # get response xml document
      doc = REXML::Document.new resp.body
      
      # total item
      @result_count = doc.root.attribute('total').value
      
      # get level 2 group
      groups = doc.get_elements('/talia:result/talia:entry')
      # collect result. It create an array of hash {title, description}
      @result = groups.collect do |item|
        # collect keywords
        keywords = item.elements['talia:metadata/talia:keywords'].collect do |keyword|
          {:uri => TaliaCore::Keyword.uri_for(keyword.text), :value => keyword.text}
        end
        # collect authors
        authors = item.elements['talia:metadata/talia:authors'].collect do |author|
          author.children.to_s
        end
        {:title => item.elements['talia:metadata/talia:standard_title'].text, 
         :uri => item.elements['talia:metadata/talia:uri'].text,
         :description => item.elements['talia:version/talia:content/talia:abstract'].text,
         :author => authors.join(", "),
         :date => item.elements['talia:metadata/talia:date'].text,
         :length => item.elements['talia:metadata/talia:length'].text,
         :keyword => keywords
        }
      end

    end
  end
  
end
