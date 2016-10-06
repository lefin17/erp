ActionController::Routing::Routes.draw do |map|
  map.resources :dumps

  map.resources :contract_types

  
	map.namespace :admin do |admin|
		admin.resources :users
		# admin.resources :persons
		admin.resources :product_types
		admin.resources :print_methods
		admin.resources :materials
		admin.resources :contractors
    admin.resources :print_forms, :active_scaffold => true
	end

  map.root :controller => "pages"

	# orders
  map.resources :orders, :member => {
      :update_payment => :post,
      :update_status => :post,
      :transfer => :post
  }


  map.print 'print/:id/:form_id', :controller => :print_forms, :action => :print
	#map.orders 'orders', :controller => 'orders', :action => 'index'
	#map.order_new 'orders/new', :controller => 'orders', :action => 'new'
	#map.order_view 'orders/view/:id', :controller => 'orders', :action => 'view'
	#map.order_edit 'orders/:id/edit', :controller => 'orders', :action => 'edit'

	# clients
	map.clients 'clients', :controller => 'clients', :action => 'index'
	map.client_new 'clients/new', :controller => 'clients', :action => 'new'
	map.client_view 'clients/view/:id', :controller => 'clients', :action => 'view'
	map.client_edit 'clients/:id/edit', :controller => 'clients', :action => 'edit'

  map.resources :persons
  map.resources :tasks, :collection => {:history => :get}
  map.with_options :controller => 'dialogs' do |dlg|
    dlg.dialogshow 'dialogshow/:dialogtype', :action => 'dialogshow'
    dlg.dialogselect 'dialogselect/:id', :action => 'dialogselect'
  end
  map.resources :contracttypes, :controller => 'admin/contracttypes'
  map.resources :companyactions, :controller => 'admin/companyactions'
  map.resources :userfroms, :controller => 'admin/userfroms'

	# logged-in user specific
	map.logout 'logout', :controller => 'user', :action => 'logout'
	map.profile 'profile', :controller => 'user', :action => 'profile'

	# suggests
	map.suggest_client_login 'ajax/suggest/client/login', :controller => 'clients', :action => 'login_suggest'
	# my edition
	map.suggest_client_name 'ajax/suggest/client/name', :controller => 'clients', :action => 'name_suggest'
	
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
