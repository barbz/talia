ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # See how all your routes lay out with "rake routes"
  
  # Default route
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'home', :action => 'start'

  # Routes for login and users handling
  map.resources :users
  map.login  'login',  :controller => 'sessions', :action => 'create'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.open_id_complete 'session', :controller => 'sessions', :action => 'create', :requirements => { :method => :get }
  map.resource :session

  # Routes for the sources
  map.resources :sources do |sources|
    sources.connect ':attribute', :controller => 'sources', :action => 'show_attribute'
  end
  
  # Routes for types
  map.resources :types

  # Routes for the source data
  map.connect 'source_data/:type/:location', :controller => 'source_data',
    :action => 'show',
    :requirements => { :location => /[^\/]+/ } # Force the location to match also filenames with points etc.

  map.resources :data_records, :controller => 'source_data'
  
  # Routes for the widget engine
  map.resources :widgeon, :collection => { :callback => :all } do |widgets|
    widgets.connect ':file', :controller => 'widgeon', :action => 'load_file', :requirements => { :file => %r([^;,?]+) }
  end
    
  # Routes for import
  map.connect 'import/:action', :controller => 'import', :action => 'start_import'
  
  #  map.connect ':controller/:id/:data_type/:location', 
  #              :controller => 'sources', 
  #              :action => 'show_source_data',
  #              :id => :nil,
  #              :data_type => :nil,
  #              :location  => :nil,
  #              :requirements => { :location => /[^\/]+/ } # Force the location to match also filenames with points etc.

  #TODO: find a way for usin
  map.connect "facsimile_editions/:id/search",
    :controller => 'facsimile_editions',
    :action => 'search'

  # Install the default route as the lowest priority.
  map.connect ':controller/:id', :action => 'show'
  
  map.connect "facsimile_editions/:id/:type/:subtype",
    :controller => 'facsimile_editions',
    :action => 'books',
    :requirements => { :type => /works|manuscripts|library|correspondence|pictures/ },
    :subtype => nil

  map.connect "facsimile_editions/:id/:book:dot:format",
    :controller => 'facsimile_editions',
    :action => 'panorama',
    :dot => /\.?/,
    :format => nil

  #TODO: bring it back to 'facsimile_editions/:id/:book,:page'
  # it didn't work for me, I've changed it to do some testing, and as a 
  # reminder.
  # Are we sure we can use a comma as a separator?
  map.connect "facsimile_editions/:id/:page:dot:format",
    :controller => 'facsimile_editions',
    :action => 'page',
    :dot => /\.?/,
    :format => nil,
    :requirements => {:page => /.*\,.*/}

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'  

  map.connect "facsimile_editions/:id/:book/:page/:page2",
    :controller => 'facsimile_editions',
    :action => 'facing_pages'
  
  map.resources :facsimile_edition do |facsimile_edition|
    facsimile_edition.resource :book do |book|
      book.resources :pages
    end
  end
  
end
