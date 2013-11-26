Rails.application.routes.draw do
  scope :module => :foreman_mco do
    resource :commands, :only => [] do
      get :install_package, :on => :collection
      get :uninstall_package, :on => :collection
      get :service_status, :on => :collection
      get :start_service, :on => :collection
      get :stop_service, :on => :collection
      get :ping, :on => :collection
      post :submit_command, :on => :collection
    end

    resources :command_histories, :only => [:index] do
      get :auto_complete_search, :on => :collection
    end
    resources :command_statuses, :only => [:update]

    # TODO: remove this pretty nasty hack. It's necessary because of a bug
    # in Foreman core routing which causes routes to contain the engine prefix.
    match 'users/(:action)', :to => 'users#(:action)'
  end
end
