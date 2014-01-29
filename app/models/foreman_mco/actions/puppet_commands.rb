module ForemanMco
  module Actions
    class PuppetRunOnce < BaseAction
      def remote_call
        mco_proxy.puppet_runonce(input[:filters])
      end

      def self.humanized_name
        _("puppet runonce")
      end
    end

    class PuppetEnable < BaseAction
      def remote_call
        mco_proxy.puppet_enable(input[:filters])
      end

      def self.humanized_name
        _("puppet start")
      end
    end

    class PuppetDisable < BaseAction
      def remote_call
        mco_proxy.puppet_disable(input[:filters])
      end

      def self.humanized_name
        _("puppet stop")
      end
    end
  end
end
