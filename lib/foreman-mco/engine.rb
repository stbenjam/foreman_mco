require 'deface'

module ForemanMco
  ENGINE_NAME = "foreman_mco"

  class Engine < ::Rails::Engine
    engine_name ::ForemanMco::ENGINE_NAME

    config.autoload_paths += Dir[
      "#{config.root}/app/models/concerns",
      "#{config.root}/app/models/services"
    ]

    initializer 'foreman_mco.load_default_settings', :before => :load_config_initializers do |app|
      require_dependency File.expand_path("../../../app/models/setting/mco.rb", __FILE__) if (Setting.table_exists? rescue(false))
    end

    initializer "foreman_mco.dynflow_initialize" do |app|
      ForemanTasks.dynflow.require!
    end

    initializer 'foreman_mco.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_discovery do
        requires_foreman '> 1.3'

        sub_menu :top_menu, :orchestration_menu, :caption => N_('Orchestration')

        ::Menu::Manager.map :top_menu do |menu|
          mm = menu.find(:monitor_menu)
          old_reports = mm.find {|i| i.name == :reports}
          mm.remove!(old_reports)          
        end

        sub_menu :top_menu, :reports, :parent => :monitor_menu, :caption => N_('Reports')
        menu :top_menu, :puppet_reports, :url_hash => {:controller => '/reports', :action => 'index', :search => 'eventful = true'},
          :caption=> N_('Puppet Reports'),
          :parent => :reports
        menu :top_menu, :mco_history, :url_hash => {:controller=> "foreman_mco/command_histories", :action=>:index},
          :caption=> N_('MCollective Command History'),
          :parent => :reports

        security_block :mcollective do
          permission :execute_mco_commands, {:'foreman_mco/commands' => [:install_package, :uninstall_package, :service_status, :start_service, :stop_service, :install_package, :uninstall_package,
            :puppet_runonce, :puppet_enable, :puppet_disable, :ping, :submit_command] }, :resource_type => "ForemanMco::Commands"
        end
        role "Execute MCO Commands", [:execute_mco_commands]
      end
    end

    initializer "foreman_mco.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanMco::Engine.paths['db/migrate'].existent
    end

    config.to_prepare do
      ::HostsHelper.send :include, ForemanMco::HostsHelper
    end
  end

  def table_name_prefix
    ForemanMco::ENGINE_NAME + '_'
  end

  def self.table_name_prefix
    ForemanMco::ENGINE_NAME + '_'
  end

  def use_relative_model_naming
    true
  end
end
