module ForemanMco
  module Actions
    class Ping < BaseAction
      def remote_call
        mco_proxy.ping(input[:filters])
      end

      def self.humanized_name
        _("Ping")
      end
    end
  end
end
