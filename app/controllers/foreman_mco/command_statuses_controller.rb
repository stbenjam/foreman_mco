module ForemanMco
  class CommandStatusesController < ::Api::V2::BaseController
    include ::Foreman::Controller::SmartProxyAuth

    add_puppetmaster_filters([:update])

    before_filter :find_status, :only => [:update]
#    before_filter :parse_results, :only => [:update]

    def update
      ForemanTasks.dynflow.world.executor.event(@command_status.execution_plan_id, 2, params[:command_status])
      render :nothing => true, :status => 200, :content_type => :json
#      process_response @command_status.update_attributes!(params[:command_status])
    end

    def find_status
      @command_status = ForemanMco::CommandStatus.find_by_jid(params[:id])
      render_error 'not_found', :status => :not_found and return false unless @command_status
    end

    def parse_results
      return if params[:command_status][:result].nil?
      @host_statuses = params[:command_status][:result].each {|host_status| @command_status.host_command_statuses.build(to_foreman_schema(host_status))}
    end

    def to_foreman_schema(a_hash)
      to_ret = {}
      our_schema = { "sender" => "host", "statuscode" => "status_code", "statusmsg" => "status_message", "data" => "result" }

      a_hash.each_pair do |k,v|
        our_schema.has_key?(k) ? to_ret[our_schema[k]] = v : to_ret[k] = v
      end

      to_ret
    end

    def require_mco_proxy_or_login
      if auth_smart_proxy(SmartProxy.mcollective_proxies, false)
        set_admin_user
        return true
      end

      require_login
      unless User.current
        render_error 'access_denied', :status => :forbidden unless performed? and api_request?
        return false
      end
      authorize
    end
  end
end
