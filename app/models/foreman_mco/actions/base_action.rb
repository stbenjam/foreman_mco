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
        parse_results(status)
        status.update_attributes!(output[:command_status])
      end

      def find_status
        status = ForemanMco::CommandStatus.find_by_jid(output[:jid])
        raise "couldn't find job id #{output[:jid]}" unless status
        status
      end

      def parse_results(command_status)
        return if output[:command_status][:result].nil?
        output[:command_status][:result].each {|host_status| command_status.host_command_statuses.build(to_foreman_schema(host_status))}
      end

      def to_foreman_schema(a_hash)
        to_ret = {}
        our_schema = { "sender" => "host", "statuscode" => "status_code", "statusmsg" => "status_message", "data" => "result" }

        a_hash.each_pair do |k,v|
          our_schema.has_key?(k) ? to_ret[our_schema[k]] = v : to_ret[k] = v
        end

        to_ret
      end
    end
  end
end