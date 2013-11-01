module ForemanMco
  class CommandsController < ::ApplicationController
    attr_reader :command, :mco_proxy
    before_filter :find_mco_proxy, :only => [:submit_command]
    before_filter :find_command, :only => [:submit_command]

    def install_package
    end

    #TODO: a possible race condition here -- proxy *can* process remote job before we get to CommandStatus creation
    def submit_command
      response = mco_proxy.test
      if response
        CommandStatus.create!(:command => @command, :jid => response)
        process_success :success_redirect => hosts_path(), :success_msg => _("'%s' command has been queued up for execution") % command
      else
        process_error :redirect => hosts_path(), :error_msg => _("'%s' command has not been queued up: %s") % [command, 'fail!']
      end
    rescue => e
      process_error :redirect => hosts_path(), :error_msg => _("'%s' command has not been queued up: %s") % [command, e]
    end

    def find_command
      @command = params[:command]
      return process_error :redirect => :back, :error_msg => _("No command to execute") unless @command
    end

    def find_mco_proxy
      db_proxy_record = SmartProxy.joins(:features).where("features.name" => "MCollective").first
      @mco_proxy = ForemanMco::McoProxyApi.new(:url => db_proxy_record.url)
      return process_error :redirect => :back, :error_msg => _("There are no configured mcollective proxies") unless @mco_proxy
    end
  end
end
