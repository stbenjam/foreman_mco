module ForemanMco
  class DetailedCommandHistoriesController < ::ApplicationController
    include Foreman::Controller::TaxonomyMultiple
    include Foreman::Controller::AutoCompleteSearch

    SEARCHABLE_ACTIONS= %w[index]

    def index
      begin
        search = HostCommandStatus.where(:command_status_id => params[:command_history_id]).search_for(params[:search],:order => params[:order])
      rescue => e
        error e.to_s
        search = HostCommandStatus.where(:command_status_id => params[:command_history_id])
      end
      @details = search.paginate(:page => params[:page])
    end

    def controller_name
      "command_history_detailed_command_histories"
    end

    def model_of_controller
      HostCommandStatus
    end
  end
end