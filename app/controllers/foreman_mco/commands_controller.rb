module ForemanMco
  class CommandsController < ::ApplicationController
    attr_reader :command, :mco_proxy
    before_filter :find_command, :only => [:submit_command]

    def install_package
    end

    #TODO: a possible race condition here -- proxy *can* process remote job before we get to CommandStatus creation
    def submit_command
      if @command.execute
        process_success :success_redirect => hosts_path(), :success_msg => _("'%s' command has been queued up for execution") % command
      else
        process_error :redirect => hosts_path(), :error_msg => _("'%s' command has not been queued up: %s") % [command, 'fail!']
      end
    rescue => e
      process_error :redirect => hosts_path(), :error_msg => _("'%s' command has not been queued up: %s") % [command, e]
    end

    def find_command
      return process_error :redirect => :back, :error_msg => _("No command to execute") unless params[:command]

      command_hash = params[:command]
      clazz = ("ForemanMco::Command::" + command_hash[:command].camelize).constantize
      @command = clazz.new(command_hash)

      return process_error(:redirect => :back, :object => @command, :error_msg => _("Invalid command parametres")) unless @command.valid?

      @command
    rescue NameError => e
      return process_error(:redirect => :back, :object => @command, :error_msg => _("Invalid command '%s'") % params[:command])
    end
  end
end
