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
  end
end
