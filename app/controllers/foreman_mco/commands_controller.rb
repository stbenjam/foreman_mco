require 'foreman_mco/commands'

module ForemanMco
  class CommandsController < ::ApplicationController
    COMMANDS = [:install_package, :uninstall_package, :service_status, :start_service,
      :stop_service, :install_package, :uninstall_package,
      :puppet_runonce, :puppet_enable, :puppet_disable,
      :ping]

    attr_reader :command
    before_filter :find_command_class, :only => [:submit_command]
    before_filter :filter_by_hosts, :only => COMMANDS

    COMMANDS.each do |cmd|
      define_method(cmd) {}
    end

    #TODO: a possible race condition here -- proxy *can* process remote job before we get to CommandStatus creation
    def submit_command
      @command = ForemanTasks.trigger(@command_class, params[:command])
      if @command
        process_success :success_redirect => :back, :success_msg => _("'%s' command has been queued up for execution") % @command_class.humanized_name
      else
        process_error :redirect => :back, :error_msg => _("'%s' command has not been queued up: %s") % [@command_class.humanized_name, 'fail!']
      end
    rescue => e
      p e.backtrace
      process_error :redirect => :back, :error_msg => _("'%s' command has not been queued up: %s") % [@command_class.humanized_name, e]
    end

    def find_command_class
      return process_error :redirect => :back, :error_msg => _("No command to execute") unless params[:command]

      command_hash = params[:command]
      @command_class = ("ForemanMco::Actions::" + command_hash[:command].camelize).constantize
#      return process_error(:redirect => :back, :object => @command, :error_msg => _("Invalid command parametres: %s") % command.errors.full_messages) unless @command.valid?
      @command_class
    rescue NameError => e
      return process_error(:redirect => :back, :object => @command, :error_msg => _("Invalid command '%s'") % params[:command])
    end

    def filter_by_hosts
      @hosts = params[:host_ids].nil? ? [] : Host.select(:name).where(:id => params[:host_ids])
      @filters = @hosts.collect(&:name).collect {|n| ::ForemanMco::Actions::Filter.identity_filter(n)}.to_json
    end
  end
end
