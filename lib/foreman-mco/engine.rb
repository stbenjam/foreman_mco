module ForemanMco
  ENGINE_NAME = "foreman_mco"

  class Engine < ::Rails::Engine
    engine_name ::ForemanMco::ENGINE_NAME

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    initializer 'foreman-mco.load_default_settings', :before => :load_config_initializers do |app|
      require_dependency File.expand_path("../../../app/models/setting/mco.rb", __FILE__) if (Setting.table_exists? rescue(false))
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
