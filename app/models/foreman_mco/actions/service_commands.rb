module ForemanMco
  module Actions
    class ServiceStatus < BaseAction
      def remote_call
        mco_proxy.service_status(input[:service_name], input[:filters])
      end

      def self.humanized_name
        _("Service Status")
      end
    end

    class StartService < BaseAction
      def remote_call
        mco_proxy.start_service(input[:service_name], input[:filters])
      end

      def self.humanized_name
        _("Start Service")
      end
    end

    class StopService < BaseAction
      def remote_call
        mco_proxy.stop_service(input[:service_name], input[:filters])
      end

      def self.humanized_name
        _("Stop Service")
      end
    end
  end
end
