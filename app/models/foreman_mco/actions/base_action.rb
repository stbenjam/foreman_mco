module ForemanMco
  module Actions
    class BaseAction < ::Actions::EntryAction
      def run(event = nil)
        case event
          when nil
            response = remote_call
            output[:jid] = response.split("/tasks/")[1]
            ::ForemanMco::CommandStatus.create!(:command => humanized_name, :jid => output[:jid], :execution_plan_id => execution_plan_id)
            suspend
          else
            # resumed
            output[:command_status] = event
            update_command_status
        end
      end

      def self.humanized_name
        self.class.to_s
      end

      def humanized_name
        self.class.humanized_name
      end

      def mco_proxy
        db_proxy_record = SmartProxy.joins(:features).where("features.name" => "MCollective").first
        raise ::Foreman::Exception.new(N_("There are no configured mcollective proxies")) unless db_proxy_record
        ForemanMco::McoProxyApi.new(:url => db_proxy_record.url)
      end

     def update_command_status
        status = find_status
        build_host_statuses(status)
        status.update_attributes!(build_command_status)
      end

      def find_status
        status = ForemanMco::CommandStatus.find_by_jid(output[:jid])
        raise "couldn't find job id #{output[:jid]}" unless status
        status
      end

      def build_host_statuses(command_status)
        return if output[:command_status].nil?
        output[:command_status].each {|host_status| command_status.host_command_statuses.build(to_foreman_schema(host_status))}
      end

      def build_command_status()
        return { :status => "No Data" } if output[:command_status].nil?
        statuscodes = output[:command_status].collect {|cs| cs["body"]["statuscode"]}
        { :status => status_code_to_message(statuscodes.first) }
      end

      def status_code_to_message(code)
        case code
        when 0
          "Success"
        when 1
          "All the data parsed ok, we have a action matching the request but the requested action could not be completed."
        when 2
          "Unknown Action"
        when 3
          "Missing Data"
        when 4
          "Invalid Data"
        when 5
          "Other Error"
        else 
          "No Error Data"
        end
      end

      def to_foreman_schema(a_hash)
        {
          :host => a_hash["senderid"],
          :status_code => status_code_to_message(a_hash["body"]["statuscode"]),
          :status_message => (a_hash["body"]["statusmsg"] rescue ""),
          :result => (a_hash["body"]["data"] rescue ""),
          :agent => a_hash["senderagent"]
        }
      end
    end
  end
end