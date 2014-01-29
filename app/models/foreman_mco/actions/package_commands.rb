module ForemanMco
  module Actions
    class InstallPackage < BaseAction
      def remote_call
        mco_proxy.install_package(input[:package_name], input[:filters])
      end

      def self.humanized_name
        _("Install Package")
      end
    end

    class UninstallPackage < BaseAction
      def remote_call
        mco_proxy.uninstall_package(input[:package_name], input[:filters])
      end

      def self.humanized_name
        _("Uninstall Package")
      end
    end
  end
end