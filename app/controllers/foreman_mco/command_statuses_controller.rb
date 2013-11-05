module ForemanMco
  class CommandStatusesController < ::Api::V2::BaseController
    include ::Foreman::Controller::SmartProxyAuth
    before_filter :find_status, :only => [:update]

    def update
      process_response @command_status.update_attributes!(params[:command_status])
    end

    def find_status
      @command_status = ForemanMco::CommandStatus.find_by_jid(params[:id])
      render_error 'not_found', :status => :not_found and return false unless @command_status
    end
  end
end
