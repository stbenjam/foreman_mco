Rails.application.routes.draw do
  scope :module => :foreman_mco do
    resource :commands, :only => [] do
      get :install_package, :on => :collection
      post :submit_command, :on => :collection
    end

    resources :command_statuses, :only => [:update]
  end
end
