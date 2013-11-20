require 'foreman_mco/commands'

module ForemanMco
  class CommandsController < ::ApplicationController
    COMMANDS = [:install_package, :uninstall_package, :service_status, :start_service, :stop_service, :install_package, :uninstall_package, :ping]

    attr_reader :command
    before_filter :find_command, :only => [:submit_command]
    before_filter :filter_by_hosts, :only => COMMANDS

    COMMANDS.each do |cmd|
      define_method(cmd) {}
    end

    #TODO: a possible race condition here -- proxy *can* process remote job before we get to CommandStatus creation
    def submit_command
      if @command.execute
        process_success :success_redirect => :back, :success_msg => _("'%s' command has been queued up for execution") % command
      else
        process_error :redirect => :back, :error_msg => _("'%s' command has not been queued up: %s") % [command, 'fail!']
      end
    rescue => e
      process_error :redirect => :back, :error_msg => _("'%s' command has not been queued up: %s") % [command, e]
    end

    def find_command
      return process_error :redirect => :back, :error_msg => _("No command to execute") unless params[:command]

      command_hash = params[:command]
      clazz = ("ForemanMco::Command::" + command_hash[:command].camelize).constantize
      @command = clazz.new(command_hash)

      return process_error(:redirect => :back, :object => @command, :error_msg => _("Invalid command parametres: %s") % command.errors.full_messages) unless @command.valid?

      @command
    rescue NameError => e
      return process_error(:redirect => :back, :object => @command, :error_msg => _("Invalid command '%s'") % params[:command])
    end

    def filter_by_hosts
      host_names = params[:host_ids].nil? ? [] : Host.select(:name).where(:id => params[:host_ids]).collect(&:name)
      @filters = host_names.collect {|n| ::ForemanMco::Command::Filter.identity_filter(n)}
    end
  end
end
