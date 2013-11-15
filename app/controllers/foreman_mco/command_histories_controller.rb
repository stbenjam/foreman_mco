module ForemanMco
  class CommandHistoriesController < ::ApplicationController
    include Foreman::Controller::TaxonomyMultiple
    include Foreman::Controller::AutoCompleteSearch

    SEARCHABLE_ACTIONS= %w[index]

    def index
      begin
        search = CommandStatus.search_for(params[:search],:order => params[:order])
      rescue => e
        error e.to_s
        search = CommandStatus.search_for ''
      end
      @command_statuses = search.paginate(:page => params[:page])
    end

    def model_of_controller
      CommandStatus
    end

  end
end