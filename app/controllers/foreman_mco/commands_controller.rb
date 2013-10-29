module ForemanMco
  class CommandsController < ::ApplicationController
    before_filter :find_command, :only => [:submit_command]

    def install_package
    end

    def submit_command
      success = true
      if success
        process_success :success_redirect => hosts_path(), :success_msg => _("'%s' command has been queued up for execution") % command
      else
        process_error :redirect => hosts_path(), :error_msg => _("'%s' command has not been queued up: %s") % [command, 'fail!']
      end
    rescue => e
      process_error :redirect => hosts_path(), :error_msg => _("'%s' command has not been queued up: %s") % [command, e]
    end

    attr_reader :command
    def find_command
      @command = params[:command]
      return process_error :redirect => :back, :error_msg => _("No command to execute") unless @command
    end

    def find_smart_proxy
      @mc_proxy = SmartProxy.joins(:features).where("features.name" => "MCollective").first
      return process_error :redirect => :back, :error_msg => _("There are no configured mcollective proxies") unless @mc_proxy
    end
  end
end
